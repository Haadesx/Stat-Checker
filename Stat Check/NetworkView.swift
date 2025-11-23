//
//  NetworkView.swift
//  Stat Check
//
//  Created by Varesh Patel on 11/23/25.
//

import SwiftUI

struct NetworkView: View {
    @EnvironmentObject var systemMonitor: SystemMonitor
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Network Activity")
                .font(.title)
                .fontWeight(.bold)
            
            HStack(spacing: 20) {
                NetworkCard(title: "Download",
                            value: systemMonitor.networkUsage.downloadSpeed,
                            icon: "arrow.down.circle.fill",
                            color: .green)
                
                NetworkCard(title: "Upload",
                            value: systemMonitor.networkUsage.uploadSpeed,
                            icon: "arrow.up.circle.fill",
                            color: .red)
            }
            .padding()
            
            HistoryChartView(data: systemMonitor.networkDownloadHistory, color: .green, title: "Download History", yAxisLabel: "Bytes/s", formatType: .bytes)
            HistoryChartView(data: systemMonitor.networkUploadHistory, color: .red, title: "Upload History", yAxisLabel: "Bytes/s", formatType: .bytes)
        }
        .padding()
    }
}

struct NetworkCard: View {
    let title: String
    let value: Double
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 15) {
            Image(systemName: icon)
                .font(.system(size: 40))
                .foregroundColor(color)
            
            Text(title)
                .font(.headline)
                .foregroundColor(.secondary)
            
            Text(formatSpeed(value))
                .font(.title2)
                .fontWeight(.bold)
                .monospacedDigit()
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Material.ultraThinMaterial)
        .cornerRadius(12)
    }
    
    private func formatSpeed(_ bytesPerSecond: Double) -> String {
        if bytesPerSecond < 1 { return "0 B/s" }
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useAll]
        formatter.countStyle = .memory
        return formatter.string(fromByteCount: Int64(bytesPerSecond)) + "/s"
    }
}

#Preview {
    NetworkView()
        .environmentObject(SystemMonitor())
}
