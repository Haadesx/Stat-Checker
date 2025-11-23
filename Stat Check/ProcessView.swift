//
//  ProcessView.swift
//  Stat Check
//
//  Created by Varesh Patel on 11/23/25.
//

import SwiftUI

struct ProcessView: View {
    @StateObject private var processMonitor = ProcessMonitor()
    @State private var sortOrder: [KeyPathComparator<AppProcessInfo>] = [
        .init(\.cpuUsage, order: .reverse)
    ]
    @State private var searchText = ""
    
    var filteredProcesses: [AppProcessInfo] {
        let filtered = searchText.isEmpty ? processMonitor.processes : processMonitor.processes.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        return filtered.sorted(using: sortOrder)
    }
    
    var body: some View {
        Table(filteredProcesses, sortOrder: $sortOrder) {
            TableColumn("Name", value: \.name) { process in
                HStack {
                    if let icon = process.icon {
                        Image(nsImage: icon)
                            .resizable()
                            .frame(width: 16, height: 16)
                    } else {
                        Image(systemName: "app.dashed")
                    }
                    Text(process.name)
                }
            }
            
            TableColumn("CPU", value: \.cpuUsage) { process in
                Text(String(format: "%.2f%%", process.cpuUsage * 100))
                    .monospacedDigit()
            }
            
            TableColumn("Memory", value: \.memoryUsage) { process in
                Text(ByteCountFormatter.string(fromByteCount: Int64(process.memoryUsage), countStyle: .memory))
                    .monospacedDigit()
            }
        }
        .searchable(text: $searchText)
        .navigationTitle("Processes")
        .onAppear {
            processMonitor.startMonitoring()
        }
        .onDisappear {
            processMonitor.stopMonitoring()
        }
    }
}

#Preview {
    ProcessView()
}
