//
//  ContentView.swift
//  Stat Check
//
//  Created by Varesh Patel on 11/23/25.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedItem: SidebarItem? = .dashboard
    
    enum SidebarItem: String, Identifiable, CaseIterable {
        case dashboard = "Dashboard"
        case cpu = "CPU"
        case memory = "Memory"
        case disk = "Disk"
        case network = "Network"
        case processes = "Processes"
        case insights = "Insights"
        
        var id: String { rawValue }
        var icon: String {
            switch self {
            case .dashboard: return "square.grid.2x2"
            case .cpu: return "cpu"
            case .memory: return "memorychip"
            case .disk: return "internaldrive"
            case .network: return "network"
            case .processes: return "list.bullet.rectangle"
            case .insights: return "chart.xyaxis.line"
            }
        }
    }

    var body: some View {
        NavigationSplitView {
            List(SidebarItem.allCases, selection: $selectedItem) { item in
                NavigationLink(value: item) {
                    Label(item.rawValue, systemImage: item.icon)
                }
            }
            .navigationTitle("Stat Check")
#if os(macOS)
            .navigationSplitViewColumnWidth(min: 180, ideal: 200)
#endif
        } detail: {
            switch selectedItem {
            case .dashboard:
                DashboardView()
            case .cpu:
                CPUView()
            case .memory:
                MemoryView()
            case .disk:
                DiskView()
            case .network:
                NetworkView()
            case .processes:
                ProcessView()
            case .insights:
                InsightsView()
            case .none:
                Text("Select an item")
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(SystemMonitor())
}
