//
//  Item.swift
//  Three Coins
//
//  Created by Jacopo Donati on 16/02/24.
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
