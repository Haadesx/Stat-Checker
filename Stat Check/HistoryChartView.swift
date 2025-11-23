//
//  HistoryChartView.swift
//  Stat Check
//
//  Created by Varesh Patel on 11/23/25.
//

import SwiftUI
import Charts

struct HistoryChartView: View {
    enum FormatType {
        case number
        case bytes
        case percent
    }
    
    let data: [SystemMonitor.StatPoint]
    let color: Color
    let title: String
    let yAxisLabel: String
    var isDynamicScale: Bool = false
    var formatType: FormatType = .number
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline)
                .foregroundColor(.secondary)
            
            Chart(data) { point in
                AreaMark(
                    x: .value("Time", point.timestamp),
                    y: .value("Value", point.value)
                )
                .foregroundStyle(LinearGradient(colors: [color.opacity(0.5), color.opacity(0.1)], startPoint: .top, endPoint: .bottom))
                .interpolationMethod(.catmullRom)
                
                LineMark(
                    x: .value("Time", point.timestamp),
                    y: .value("Value", point.value)
                )
                .foregroundStyle(color)
                .interpolationMethod(.catmullRom)
            }
            .chartYAxis {
                AxisMarks(position: .leading) { value in
                    if formatType == .bytes {
                        AxisValueLabel {
                            if let doubleValue = value.as(Double.self) {
                                Text(ByteCountFormatter.string(fromByteCount: Int64(doubleValue), countStyle: .memory))
                            }
                        }
                        AxisGridLine()
                    } else {
                        AxisValueLabel()
                        AxisGridLine()
                    }
                }
            }
            .chartXAxis {
                AxisMarks(values: .automatic) { _ in
                    // Hide X axis labels for cleaner look
                }
            }
            .chartYScale(domain: isDynamicScale ? .automatic(includesZero: false) : .automatic(includesZero: true))
            .animation(.easeInOut(duration: 0.5), value: data.map { $0.value })
            .frame(height: 150)
        }
        .padding()
        .background(Material.ultraThinMaterial)
        .cornerRadius(12)
    }
}

#Preview {
    HistoryChartView(
        data: [
            .init(timestamp: Date(), value: 0.5),
            .init(timestamp: Date().addingTimeInterval(-10), value: 0.3),
            .init(timestamp: Date().addingTimeInterval(-20), value: 0.8)
        ],
        color: .blue,
        title: "CPU History",
        yAxisLabel: "Load"
    )
}
