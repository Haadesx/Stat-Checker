//
//  DiskView.swift
//  Stat Check
//
//  Created by Varesh Patel on 11/23/25.
//

import SwiftUI

struct DiskView: View {
    @EnvironmentObject var systemMonitor: SystemMonitor
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Disk Usage")
                .font(.title)
                .fontWeight(.bold)
            
            ZStack {
                Circle()
                    .stroke(lineWidth: 20)
                    .opacity(0.3)
                    .foregroundColor(.purple)
                
                Circle()
                    .trim(from: 0.0, to: CGFloat(systemMonitor.diskUsage.percentage))
                    .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round, lineJoin: .round))
                    .foregroundColor(.purple)
                    .rotationEffect(Angle(degrees: 270.0))
                    .animation(.linear, value: systemMonitor.diskUsage.percentage)
                
                VStack {
                    Text(String(format: "%.2f%%", systemMonitor.diskUsage.percentage * 100))
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Text("Used")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .frame(width: 200, height: 200)
            .padding()
            
            HStack(spacing: 40) {
                VStack {
                    Text("Used")
                        .font(.headline)
                        .foregroundColor(.purple)
                    Text(ByteCountFormatter.string(fromByteCount: systemMonitor.diskUsage.used, countStyle: .file))
                }
                
                VStack {
                    Text("Free")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    Text(ByteCountFormatter.string(fromByteCount: systemMonitor.diskUsage.free, countStyle: .file))
                }
                
                VStack {
                    Text("Total")
                        .font(.headline)
                    Text(ByteCountFormatter.string(fromByteCount: systemMonitor.diskUsage.total, countStyle: .file))
                }
            }
            .padding()
            .background(Material.ultraThinMaterial)
            .cornerRadius(12)
        }
        .padding()
    }
}

#Preview {
    DiskView()
        .environmentObject(SystemMonitor())
}
