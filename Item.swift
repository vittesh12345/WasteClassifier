//
//  Item.swift
//  WasteClassifier
//
//  Created by   Vittesh Maganti on 3/8/25.
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
