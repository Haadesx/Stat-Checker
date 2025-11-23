//
//  SystemMonitor.swift
//  Stat Check
//
//  Created by Varesh Patel on 11/23/25.
//

import Foundation
import Combine
import Darwin
import SwiftData

struct CPUUsage {
    var system: Double = 0
    var user: Double = 0
    var idle: Double = 0
    var total: Double { system + user }
}

struct MemoryUsage {
    var used: UInt64 = 0
    var total: UInt64 = 0
    var free: UInt64 { total > used ? total - used : 0 }
    var percentage: Double { total > 0 ? Double(used) / Double(total) : 0 }
}

struct DiskUsage {
    var used: Int64 = 0
    var total: Int64 = 0
    var free: Int64 = 0
    var percentage: Double { total > 0 ? Double(used) / Double(total) : 0 }
}

struct NetworkUsage {
    var uploadSpeed: Double = 0 // Bytes per second
    var downloadSpeed: Double = 0 // Bytes per second
}

class SystemMonitor: ObservableObject {
    @Published var cpuUsage = CPUUsage()
    @Published var memoryUsage = MemoryUsage()
    @Published var diskUsage = DiskUsage()
    @Published var networkUsage = NetworkUsage()
    
    private var timer: Timer?
    private var previousNetworkInfo: (upload: UInt64, download: UInt64)?
    private var previousTime: Date?
    
    // CPU Load properties
    private var previousCPULoadInfo: host_cpu_load_info?
    
    init() {
        startMonitoring()
    }
    
    deinit {
        stopMonitoring()
    }
    
    func startMonitoring() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateStats()
        }
        updateStats() // Initial update
    }
    
    func stopMonitoring() {
        timer?.invalidate()
        timer = nil
    }
    
    // MARK: - History & Persistence
    struct StatPoint: Identifiable {
        let id = UUID()
        let timestamp: Date
        let value: Double
    }
    
    @Published var cpuHistory: [StatPoint] = []
    @Published var memoryHistory: [StatPoint] = []
    @Published var networkDownloadHistory: [StatPoint] = []
    @Published var networkUploadHistory: [StatPoint] = []
    
    private var modelContext: ModelContext?
    private var lastLogTime: Date = Date()
    private let logInterval: TimeInterval = 60 // Log every minute
    
    func setModelContext(_ context: ModelContext) {
        self.modelContext = context
    }
    
    private func updateStats() {
        updateCPU()
        updateMemory()
        updateDisk()
        updateNetwork()
        
        let now = Date()
        
        // Update Live History (Keep last 30 seconds)
        let retention: TimeInterval = 30
        
        DispatchQueue.main.async {
            self.cpuHistory.append(StatPoint(timestamp: now, value: self.cpuUsage.total))
            // Store raw bytes for memory history to allow for better dynamic scaling (e.g. 12GB vs 12.1GB)
            self.memoryHistory.append(StatPoint(timestamp: now, value: Double(self.memoryUsage.used)))
            self.networkDownloadHistory.append(StatPoint(timestamp: now, value: self.networkUsage.downloadSpeed))
            self.networkUploadHistory.append(StatPoint(timestamp: now, value: self.networkUsage.uploadSpeed))
            
            self.cpuHistory = self.cpuHistory.filter { $0.timestamp > now.addingTimeInterval(-retention) }
            self.memoryHistory = self.memoryHistory.filter { $0.timestamp > now.addingTimeInterval(-retention) }
            self.networkDownloadHistory = self.networkDownloadHistory.filter { $0.timestamp > now.addingTimeInterval(-retention) }
            self.networkUploadHistory = self.networkUploadHistory.filter { $0.timestamp > now.addingTimeInterval(-retention) }
            
            self.checkAndLog(now: now)
        }
    }
    
    private func checkAndLog(now: Date) {
        if now.timeIntervalSince(lastLogTime) >= logInterval {
            saveLog(now: now)
            lastLogTime = now
        }
    }
    
    private func saveLog(now: Date) {
        guard let context = modelContext else { return }
        
        let log = StatLog(
            timestamp: now,
            cpuTotal: cpuUsage.total,
            memoryUsed: Int64(memoryUsage.used),
            diskUsed: diskUsage.used,
            networkDownload: networkUsage.downloadSpeed,
            networkUpload: networkUsage.uploadSpeed
        )
        
        context.insert(log)
        
        // Optional: Save context explicitly if needed, though SwiftData autosaves
        // try? context.save()
    }
    
    // MARK: - CPU
    private func updateCPU() {
        var size = mach_msg_type_number_t(MemoryLayout<host_cpu_load_info>.size / MemoryLayout<integer_t>.size)
        var cpuLoadInfo = host_cpu_load_info()
        
        let result = withUnsafeMutablePointer(to: &cpuLoadInfo) {
            $0.withMemoryRebound(to: integer_t.self, capacity: Int(size)) {
                host_statistics(mach_host_self(), HOST_CPU_LOAD_INFO, $0, &size)
            }
        }
        
        if result == KERN_SUCCESS {
            if let previous = previousCPULoadInfo {
                let userDiff = Double(cpuLoadInfo.cpu_ticks.0 - previous.cpu_ticks.0)
                let systemDiff = Double(cpuLoadInfo.cpu_ticks.1 - previous.cpu_ticks.1)
                let idleDiff = Double(cpuLoadInfo.cpu_ticks.2 - previous.cpu_ticks.2)
                let niceDiff = Double(cpuLoadInfo.cpu_ticks.3 - previous.cpu_ticks.3)
                
                let totalTicks = userDiff + systemDiff + idleDiff + niceDiff
                
                if totalTicks > 0 {
                    let user = (userDiff + niceDiff) / totalTicks
                    let system = systemDiff / totalTicks
                    let idle = idleDiff / totalTicks
                    
                    DispatchQueue.main.async {
                        self.cpuUsage = CPUUsage(system: system, user: user, idle: idle)
                    }
                }
            }
            previousCPULoadInfo = cpuLoadInfo
        }
    }
    
    // MARK: - Memory
    private func updateMemory() {
        var size = mach_msg_type_number_t(MemoryLayout<vm_statistics64>.size / MemoryLayout<integer_t>.size)
        var vmStats = vm_statistics64()
        
        let result = withUnsafeMutablePointer(to: &vmStats) {
            $0.withMemoryRebound(to: integer_t.self, capacity: Int(size)) {
                host_statistics64(mach_host_self(), HOST_VM_INFO64, $0, &size)
            }
        }
        
        if result == KERN_SUCCESS {
            let pageSize = UInt64(vm_kernel_page_size)
            // Active + Wired + Compressed (approximate "Used")
            // Note: Activity Monitor calculates "Memory Used" as App Memory + Wired Memory + Compressed
            // App Memory = (internal - purgeable)
            // This is a simplified calculation
            
            let active = UInt64(vmStats.active_count) * pageSize
            let wired = UInt64(vmStats.wire_count) * pageSize
            let compressed = UInt64(vmStats.compressor_page_count) * pageSize
            
            let used = active + wired + compressed
            let total = ProcessInfo.processInfo.physicalMemory
            
            DispatchQueue.main.async {
                self.memoryUsage = MemoryUsage(used: used, total: total)
            }
        }
    }
    
    // MARK: - Disk
    private func updateDisk() {
        do {
            let fileURL = URL(fileURLWithPath: "/")
            let values = try fileURL.resourceValues(forKeys: [.volumeTotalCapacityKey, .volumeAvailableCapacityKey])
            
            if let total = values.volumeTotalCapacity, let available = values.volumeAvailableCapacity {
                let used = Int64(total - available)
                DispatchQueue.main.async {
                    self.diskUsage = DiskUsage(used: used, total: Int64(total), free: Int64(available))
                }
            }
        } catch {
            print("Error retrieving disk usage: \(error)")
        }
    }
    
    // MARK: - Network
    private func updateNetwork() {
        var ifaddr: UnsafeMutablePointer<ifaddrs>?
        
        guard getifaddrs(&ifaddr) == 0 else { return }
        defer { freeifaddrs(ifaddr) }
        
        var totalUpload: UInt64 = 0
        var totalDownload: UInt64 = 0
        
        var ptr = ifaddr
        while ptr != nil {
            let interface = ptr!.pointee
            let name = String(cString: interface.ifa_name)
            
            // Filter for common interfaces (en0 is usually Wi-Fi, en1/en2 etc)
            // Excluding loopback (lo0)
            if name.hasPrefix("en") || name.hasPrefix("pdp_ip") {
                if let data = interface.ifa_data {
                    let networkData = data.assumingMemoryBound(to: if_data.self).pointee
                    totalUpload += UInt64(networkData.ifi_obytes)
                    totalDownload += UInt64(networkData.ifi_ibytes)
                }
            }
            
            ptr = interface.ifa_next
        }
        
        let currentTime = Date()
        
        if let prevInfo = previousNetworkInfo, let prevTime = previousTime {
            let timeDiff = currentTime.timeIntervalSince(prevTime)
            if timeDiff > 0 {
                let uploadDiff = Double(totalUpload - prevInfo.upload)
                let downloadDiff = Double(totalDownload - prevInfo.download)
                
                let uploadSpeed = uploadDiff / timeDiff
                let downloadSpeed = downloadDiff / timeDiff
                
                DispatchQueue.main.async {
                    self.networkUsage = NetworkUsage(uploadSpeed: uploadSpeed, downloadSpeed: downloadSpeed)
                }
            }
        }
        
        previousNetworkInfo = (totalUpload, totalDownload)
        previousTime = currentTime
    }
}
