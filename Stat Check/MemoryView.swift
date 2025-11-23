//
//  MemoryView.swift
//  Stat Check
//
//  Created by Varesh Patel on 11/23/25.
//

import SwiftUI

struct MemoryView: View {
    @EnvironmentObject var systemMonitor: SystemMonitor
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Memory Usage")
                .font(.title)
                .fontWeight(.bold)
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                    
                    Rectangle()
                        .fill(Color.orange)
                        .frame(width: geometry.size.width * CGFloat(systemMonitor.memoryUsage.percentage))
                    
                    Text(String(format: "%.2f%%", systemMonitor.memoryUsage.percentage * 100))
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .shadow(radius: 1)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            }
            .frame(height: 30)
            .cornerRadius(15)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Color.gray.opacity(0.5), lineWidth: 1)
            )
            .padding(.horizontal)
            
            HStack(spacing: 40) {
                VStack(alignment: .leading) {
                    Text("Used")
                        .font(.headline)
                        .foregroundColor(.orange)
                    Text(ByteCountFormatter.string(fromByteCount: Int64(systemMonitor.memoryUsage.used), countStyle: .memory))
                        .font(.title2)
                }
                
                VStack(alignment: .leading) {
                    Text("Free")
                        .font(.headline)
                        .foregroundColor(.gray)
                    Text(ByteCountFormatter.string(fromByteCount: Int64(systemMonitor.memoryUsage.free), countStyle: .memory))
                        .font(.title2)
                }
                
                VStack(alignment: .leading) {
                    Text("Total")
                        .font(.headline)
                    Text(ByteCountFormatter.string(fromByteCount: Int64(systemMonitor.memoryUsage.total), countStyle: .memory))
                        .font(.title2)
                }
            }
            .padding()
            .background(Material.ultraThinMaterial)
            .cornerRadius(12)
            
            HistoryChartView(data: systemMonitor.memoryHistory, color: .orange, title: "Memory Usage History", yAxisLabel: "Usage", isDynamicScale: true, formatType: .bytes)
        }
        .padding()
    }
}

#Preview {
    MemoryView()
        .environmentObject(SystemMonitor())
}
