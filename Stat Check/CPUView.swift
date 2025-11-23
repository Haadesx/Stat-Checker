//
//  CPUView.swift
//  Stat Check
//
//  Created by Varesh Patel on 11/23/25.
//

import SwiftUI

struct CPUView: View {
    @EnvironmentObject var systemMonitor: SystemMonitor
    
    var body: some View {
        VStack(spacing: 20) {
            Text("CPU Load")
                .font(.title)
                .fontWeight(.bold)
            
            ZStack {
                Circle()
                    .stroke(lineWidth: 20)
                    .opacity(0.3)
                    .foregroundColor(.blue)
                
                Circle()
                    .trim(from: 0.0, to: CGFloat(systemMonitor.cpuUsage.total))
                    .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round, lineJoin: .round))
                    .foregroundColor(.blue)
                    .rotationEffect(Angle(degrees: 270.0))
                    .animation(.linear, value: systemMonitor.cpuUsage.total)
                
                VStack {
                    Text(String(format: "%.2f%%", systemMonitor.cpuUsage.total * 100))
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Text("Total Load")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .frame(width: 200, height: 200)
            .padding()
            
            HStack(spacing: 40) {
                VStack {
                    Text("System")
                        .font(.headline)
                    Text(String(format: "%.2f%%", systemMonitor.cpuUsage.system * 100))
                        .foregroundColor(.secondary)
                }
                
                VStack {
                    Text("User")
                        .font(.headline)
                    Text(String(format: "%.2f%%", systemMonitor.cpuUsage.user * 100))
                        .foregroundColor(.secondary)
                }
                
                VStack {
                    Text("Idle")
                        .font(.headline)
                    Text(String(format: "%.2f%%", systemMonitor.cpuUsage.idle * 100))
                        .foregroundColor(.secondary)
                }
            }
            .padding()
            .background(Material.ultraThinMaterial)
            .cornerRadius(12)
            
            HistoryChartView(data: systemMonitor.cpuHistory, color: .blue, title: "Last 30 Seconds", yAxisLabel: "Load")
        }
        .padding()
    }
}

#Preview {
    CPUView()
        .environmentObject(SystemMonitor())
}
