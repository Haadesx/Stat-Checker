//
//  StatLog.swift
//  Stat Check
//
//  Created by Varesh Patel on 11/23/25.
//

import Foundation
import SwiftData

@Model
final class StatLog {
    var timestamp: Date
    var cpuTotal: Double
    var memoryUsed: Int64
    var diskUsed: Int64
    var networkDownload: Double
    var networkUpload: Double
    
    init(timestamp: Date, cpuTotal: Double, memoryUsed: Int64, diskUsed: Int64, networkDownload: Double, networkUpload: Double) {
        self.timestamp = timestamp
        self.cpuTotal = cpuTotal
        self.memoryUsed = memoryUsed
        self.diskUsed = diskUsed
        self.networkDownload = networkDownload
        self.networkUpload = networkUpload
    }
}
