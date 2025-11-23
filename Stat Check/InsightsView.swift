//
//  InsightsView.swift
//  Stat Check
//
//  Created by Varesh Patel on 11/23/25.
//

import SwiftUI
import SwiftData
import Charts

struct InsightsView: View {
    @Query(sort: \StatLog.timestamp, order: .forward) private var logs: [StatLog]
    @State private var timeRange: TimeRange = .day
    
    enum TimeRange: String, CaseIterable, Identifiable {
        case day = "Last 24 Hours"
        case week = "Last 7 Days"
        case month = "Last 30 Days"
        
        var id: String { rawValue }
    }
    
    var filteredLogs: [StatLog] {
        let now = Date()
        let interval: TimeInterval
        switch timeRange {
        case .day: interval = 86400
        case .week: interval = 86400 * 7
        case .month: interval = 86400 * 30
        }
        return logs.filter { $0.timestamp > now.addingTimeInterval(-interval) }
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Picker("Time Range", selection: $timeRange) {
                    ForEach(TimeRange.allCases) { range in
                        Text(range.rawValue).tag(range)
                    }
                }
                .pickerStyle(.segmented)
                .padding()
                
                if filteredLogs.isEmpty {
                    ContentUnavailableView("No Data Yet", systemImage: "chart.bar", description: Text("Wait for the app to collect some data."))
                } else {
                    VStack(alignment: .leading) {
                        Text("CPU Activity")
                            .font(.headline)
                        Chart(filteredLogs) { log in
                            BarMark(
                                x: .value("Time", log.timestamp, unit: .hour),
                                y: .value("Load", log.cpuTotal)
                            )
                            .foregroundStyle(.blue)
                        }
                        .frame(height: 200)
                    }
                    .padding()
                    .background(Material.ultraThinMaterial)
                    .cornerRadius(12)
                    
                    VStack(alignment: .leading) {
                        Text("Memory Usage")
                            .font(.headline)
                        Chart(filteredLogs) { log in
                            LineMark(
                                x: .value("Time", log.timestamp, unit: .hour),
                                y: .value("Used", Double(log.memoryUsed) / 1024 / 1024 / 1024) // GB
                            )
                            .foregroundStyle(.orange)
                        }
                        .chartYAxisLabel("GB")
                        .frame(height: 200)
                    }
                    .padding()
                    .background(Material.ultraThinMaterial)
                    .cornerRadius(12)
                    
                    VStack(alignment: .leading) {
                        Text("Productivity Insights")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        if let peak = filteredLogs.max(by: { $0.cpuTotal < $1.cpuTotal }) {
                            Text("Peak Activity: \(peak.timestamp.formatted(date: .omitted, time: .shortened))")
                                .font(.headline)
                            Text("High CPU load detected at this time.")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding()
                    .background(Material.ultraThinMaterial)
                    .cornerRadius(12)
                }
            }
            .padding()
        }
        .navigationTitle("Insights")
    }
}

#Preview {
    InsightsView()
        .modelContainer(for: StatLog.self, inMemory: true)
}
