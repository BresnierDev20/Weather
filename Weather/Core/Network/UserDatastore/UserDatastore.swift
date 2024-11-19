//
//  UserDatastore.swift
//  WeatherTest
//
//  Created by Angelber Castro on 16/11/24.
//

import Foundation
import Combine

class UserDatastore {
    private let locationKey = "location"

    // Guardar ubicación
    func storeLocation(_ location: CoordinatorDt) {
        var locations = getLocations()
        locations.append(location)
        storeLocations(locations)
    }

    // guardar el arreglo completo de ubicaciones
    private func storeLocations(_ locations: [CoordinatorDt]) {
        if let encoded = try? JSONEncoder().encode(locations) {
            UserDefaults.standard.set(encoded, forKey: locationKey)
        }
    }

    // Recuperar ubicación
    func getLocations() -> [CoordinatorDt] {
        if let data = UserDefaults.standard.data(forKey: locationKey),
           let decoded = try? JSONDecoder().decode([CoordinatorDt].self, from: data) {
            return decoded
        }
        return []
    }

    // Eliminar ubicación por su ID
    func deleteLocation(withId id: UUID) {
        var locations = getLocations()
        locations.removeAll { $0.id == id }
        storeLocations(locations)
    }

    // Eliminar todas las ubicaciones
    func deleteLocations() {
        UserDefaults.standard.removeObject(forKey: locationKey)
    }
}

struct CoordinatorDt: Codable, Identifiable {
    var id = UUID()
    let lat: Double
    let lon: Double
    let name: String
}
