//
//  Item.swift
//  Stat Check
//
//  Created by Varesh Patel on 11/23/25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
