//
//  MenuBarView.swift
//  Stat Check
//
//  Created by Varesh Patel on 11/23/25.
//

import SwiftUI
import Charts

struct MenuBarView: View {
    @EnvironmentObject var systemMonitor: SystemMonitor
    
    var body: some View {
        VStack(spacing: 12) {
            Text("System Stats")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 4)
            
            // CPU
            HStack {
                Image(systemName: "cpu")
                    .frame(width: 20)
                VStack(alignment: .leading, spacing: 2) {
                    Text("CPU")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(String(format: "%.2f%%", systemMonitor.cpuUsage.total * 100))
                        .font(.system(.body, design: .monospaced))
                        .fontWeight(.semibold)
                }
                Spacer()
                Chart(systemMonitor.cpuHistory) { point in
                    LineMark(
                        x: .value("Time", point.timestamp),
                        y: .value("Load", point.value)
                    )
                    .foregroundStyle(.blue)
                    .interpolationMethod(.catmullRom)
                }
                .chartXAxis(.hidden)
                .chartYAxis(.hidden)
                .frame(width: 60, height: 25)
            }
            
            Divider()
            
            // Memory
            HStack {
                Image(systemName: "memorychip")
                    .frame(width: 20)
                VStack(alignment: .leading, spacing: 2) {
                    Text("RAM")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(String(format: "%.2f%%", systemMonitor.memoryUsage.percentage * 100))
                        .font(.system(.body, design: .monospaced))
                        .fontWeight(.semibold)
                }
                Spacer()
                Chart(systemMonitor.memoryHistory) { point in
                    LineMark(
                        x: .value("Time", point.timestamp),
                        y: .value("Used", point.value)
                    )
                    .foregroundStyle(.orange)
                    .interpolationMethod(.catmullRom)
                }
                .chartXAxis(.hidden)
                .chartYAxis(.hidden)
                .chartYScale(domain: .automatic(includesZero: false)) // Dynamic scaling
                .frame(width: 60, height: 25)
            }
            
            Divider()
            
            // Network
            HStack {
                Image(systemName: "network")
                    .frame(width: 20)
                VStack(alignment: .leading, spacing: 2) {
                    HStack(spacing: 4) {
                        Image(systemName: "arrow.down")
                            .font(.caption2)
                        Text(formatSpeed(systemMonitor.networkUsage.downloadSpeed))
                            .font(.caption)
                            .monospacedDigit()
                    }
                    HStack(spacing: 4) {
                        Image(systemName: "arrow.up")
                            .font(.caption2)
                        Text(formatSpeed(systemMonitor.networkUsage.uploadSpeed))
                            .font(.caption)
                            .monospacedDigit()
                    }
                }
                Spacer()
            }
            
            Divider()
            
            Button("Open Dashboard") {
                NSApp.activate(ignoringOtherApps: true)
                // This assumes the main window is available
                if let window = NSApp.windows.first {
                    window.makeKeyAndOrderFront(nil)
                }
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.small)
        }
        .padding()
        .frame(width: 220)
    }
    
    private func formatSpeed(_ bytes: Double) -> String {
        if bytes < 1 { return "0 B/s" }
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useAll]
        formatter.countStyle = .memory
        return formatter.string(fromByteCount: Int64(bytes)) + "/s"
    }
}

#Preview {
    MenuBarView()
        .environmentObject(SystemMonitor())
}
