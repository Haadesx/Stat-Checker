//
//  DashboardView.swift
//  Stat Check
//
//  Created by Varesh Patel on 11/23/25.
//

import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var systemMonitor: SystemMonitor
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 300))], spacing: 20) {
                DashboardCard(title: "CPU", icon: "cpu", color: .blue) {
                    VStack(alignment: .leading) {
                        Text(String(format: "%.2f%%", systemMonitor.cpuUsage.total * 100))
                            .font(.system(size: 36, weight: .bold))
                        ProgressView(value: systemMonitor.cpuUsage.total)
                            .tint(.blue)
                    }
                }
                
                DashboardCard(title: "Memory", icon: "memorychip", color: .orange) {
                    VStack(alignment: .leading) {
                        Text(String(format: "%.2f%%", systemMonitor.memoryUsage.percentage * 100))
                            .font(.system(size: 36, weight: .bold))
                        ProgressView(value: systemMonitor.memoryUsage.percentage)
                            .tint(.orange)
                        Text("\(ByteCountFormatter.string(fromByteCount: Int64(systemMonitor.memoryUsage.used), countStyle: .memory)) used")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                DashboardCard(title: "Disk", icon: "internaldrive", color: .purple) {
                    VStack(alignment: .leading) {
                        Text(String(format: "%.2f%%", systemMonitor.diskUsage.percentage * 100))
                            .font(.system(size: 36, weight: .bold))
                        ProgressView(value: systemMonitor.diskUsage.percentage)
                            .tint(.purple)
                        Text("\(ByteCountFormatter.string(fromByteCount: systemMonitor.diskUsage.free, countStyle: .file)) free")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                DashboardCard(title: "Network", icon: "network", color: .green) {
                    VStack(alignment: .leading, spacing: 5) {
                        HStack {
                            Image(systemName: "arrow.down")
                            Text(formatSpeed(systemMonitor.networkUsage.downloadSpeed))
                        }
                        HStack {
                            Image(systemName: "arrow.up")
                            Text(formatSpeed(systemMonitor.networkUsage.uploadSpeed))
                        }
                    }
                    .font(.subheadline)
                }
            }
            .padding()
        }
        .navigationTitle("Dashboard")
    }
    
    private func formatSpeed(_ bytes: Double) -> String {
        if bytes < 1 { return "0 B/s" }
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useAll]
        formatter.countStyle = .memory
        return formatter.string(fromByteCount: Int64(bytes)) + "/s"
    }
}

struct DashboardCard<Content: View>: View {
    let title: String
    let icon: String
    let color: Color
    let content: () -> Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                    .font(.title2)
                Text(title)
                    .font(.headline)
                    .foregroundColor(.secondary)
                Spacer()
            }
            
            content()
        }
        .padding()
        .background(Material.ultraThinMaterial)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

#Preview {
    DashboardView()
        .environmentObject(SystemMonitor())
}
