//
//  ProcessMonitor.swift
//  Stat Check
//
//  Created by Varesh Patel on 11/23/25.
//

import Foundation
import Combine
import Darwin
import AppKit

struct AppProcessInfo: Identifiable, Hashable {
    let id: Int32
    let name: String
    let icon: NSImage?
    var cpuUsage: Double
    var memoryUsage: UInt64
}

class ProcessMonitor: ObservableObject {
    @Published var processes: [AppProcessInfo] = []
    private var timer: Timer?
    
    init() {
        startMonitoring()
    }
    
    deinit {
        stopMonitoring()
    }
    
    func startMonitoring() {
        timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { [weak self] _ in
            self?.updateProcesses()
        }
        updateProcesses()
    }
    
    func stopMonitoring() {
        timer?.invalidate()
        timer = nil
    }
    
    private var previousProcessTimes: [Int32: (system: UInt64, user: UInt64, time: Date)] = [:]
    
    private func updateProcesses() {
        DispatchQueue.global(qos: .userInitiated).async {
            // 1. Get running applications from NSWorkspace (Reliable for Apps)
            let runningApps = NSWorkspace.shared.runningApplications
            var pids = Set(runningApps.map { $0.processIdentifier })
            
            // 2. Get all PIDs from libproc (Reliable for background processes)
            let allPids = self.listPids()
            pids.formUnion(allPids)
            
            var newProcesses: [AppProcessInfo] = []
            let now = Date()
            
            for pid in pids {
                // Skip kernel task (0) and launchd (1) if we can't get info, but usually we want them.
                // However, getting info for PID 0 usually fails or requires special handling.
                if pid == 0 { continue }
                
                // Try to get name
                var name: String? = nil
                var icon: NSImage? = nil
                
                // Check if it's a running app to get Icon and Name easily
                if let app = runningApps.first(where: { $0.processIdentifier == pid }) {
                    name = app.localizedName
                    icon = app.icon
                }
                
                // Fallback name fetching
                if name == nil {
                    name = self.getProcessName(pid: pid)
                }
                
                // If we still don't have a name, skip or show "Unknown"
                guard let processName = name else { continue }
                
                // Get Stats (Optional)
                let info = self.getProcessRawInfo(pid: pid)
                
                var cpuPercent: Double = 0.0
                var memoryUsage: UInt64 = 0
                
                if let info = info {
                    memoryUsage = info.memory
                    
                    if let prev = self.previousProcessTimes[pid] {
                        let timeDiff = now.timeIntervalSince(prev.time)
                        if timeDiff > 0 {
                            let systemDiff = Double(info.system - prev.system)
                            let userDiff = Double(info.user - prev.user)
                            cpuPercent = (systemDiff + userDiff) / (timeDiff * 1_000_000_000.0)
                        }
                    }
                    
                    self.previousProcessTimes[pid] = (info.system, info.user, now)
                }
                
                // If icon is still nil, maybe generic icon?
                
                newProcesses.append(AppProcessInfo(
                    id: pid,
                    name: processName,
                    icon: icon,
                    cpuUsage: cpuPercent,
                    memoryUsage: memoryUsage
                ))
            }
            
            // Clean up old PIDs
            let currentPidsSet = Set(pids)
            self.previousProcessTimes = self.previousProcessTimes.filter { currentPidsSet.contains($0.key) }
            
            DispatchQueue.main.async {
                self.processes = newProcesses
            }
        }
    }
    
    private func listPids() -> [Int32] {
        let maxPids = 4096
        var pids = [Int32](repeating: 0, count: maxPids)
        let count = proc_listpids(UInt32(PROC_ALL_PIDS), 0, &pids, Int32(maxPids * MemoryLayout<Int32>.size))
        if count <= 0 { return [] }
        let numPids = Int(count) / MemoryLayout<Int32>.size
        return Array(pids.prefix(numPids))
    }
    
    private func getProcessName(pid: Int32) -> String? {
        // Try proc_pidpath first
        var buffer = [Int8](repeating: 0, count: 4096)
        let result = proc_pidpath(pid, &buffer, UInt32(buffer.count))
        if result > 0 {
            let path = String(cString: buffer)
            return URL(fileURLWithPath: path).lastPathComponent
        }
        
        // Fallback to proc_name
        var nameBuffer = [Int8](repeating: 0, count: 256) // MAXCOMLEN is usually small
        let nameResult = proc_name(pid, &nameBuffer, UInt32(nameBuffer.count))
        if nameResult > 0 {
            return String(cString: nameBuffer)
        }
        
        return nil
    }
    
    private func getProcessRawInfo(pid: Int32) -> (system: UInt64, user: UInt64, memory: UInt64)? {
        var taskInfo = proc_taskinfo()
        let taskInfoSize = Int32(MemoryLayout<proc_taskinfo>.size)
        let result = proc_pidinfo(pid, PROC_PIDTASKINFO, 0, &taskInfo, taskInfoSize)
        
        if result == taskInfoSize {
            let memory = taskInfo.pti_resident_size
            let system = taskInfo.pti_total_system
            let user = taskInfo.pti_total_user
            return (system, user, memory)
        }
        return nil
    }
}
