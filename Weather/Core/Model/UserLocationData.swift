//
//  UserLocationData.swift
//  Weather
//
//  Created by Bresnier Moreno on 21/11/24.
//

import Foundation

struct UserLocationData: Codable, Identifiable {
    var id = UUID()
    let lat: Double
    let lon: Double
}
