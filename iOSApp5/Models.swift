//
//  Models.swift
//  iOSApp5
//
//  Created by Eezy Mongo on 2025-11-06.
//

import Foundation

struct Alarm: Identifiable, Codable, Equatable {
    var id = UUID()
    var time: Date
    var name: String = ""
    var repeatEnabled: Bool = false
    var ringtone: String = "Default"
}
