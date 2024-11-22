//
//  GeoMarker.swift
//  Weather
//
//  Created by Bresnier Moreno on 21/11/24.
//

import Foundation
import CoreLocation

struct GeoMarker {
    var latitude: Double
    var longitude: Double
    var initialLocation: CLLocationCoordinate2D

    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
        self.initialLocation = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
