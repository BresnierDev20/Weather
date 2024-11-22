//
//  Weather.swift
//  WeatherTest
//
//  Created by Angelber Castro on 14/11/24.
//

import Foundation


// Modelo principal para el JSON completo
struct WeatherResponse: Codable {
    let latitude: Double
    let longitude: Double
    let generationTimeMs: Double
    let utcOffsetSeconds: Int
    let timezone: String
    let timezoneAbbreviation: String
    let elevation: Double
    let hourlyUnits: HourlyUnits
    let hourly: HourlyData

    enum CodingKeys: String, CodingKey {
        case latitude
        case longitude
        case generationTimeMs = "generationtime_ms"
        case utcOffsetSeconds = "utc_offset_seconds"
        case timezone
        case timezoneAbbreviation = "timezone_abbreviation"
        case elevation
        case hourlyUnits = "hourly_units"
        case hourly
    }
}

struct HourlyUnits: Codable {
    let time: String
    let temperature2M: String
    let precipitation: String
    let windspeed10M: String
    let cloudcover: String

    enum CodingKeys: String, CodingKey {
        case time
        case temperature2M = "temperature_2m"
        case precipitation
        case windspeed10M = "windspeed_10m"
        case cloudcover
    }
}

// Modelo para los datos horarios en el JSON
struct HourlyData: Codable {
    let time: [String]
    let temperature2M: [Double]
    let precipitation: [Double]?
    let windspeed10M: [Double]?
    let cloudcover: [Double]?

    enum CodingKeys: String, CodingKey {
        case time
        case temperature2M = "temperature_2m"
        case precipitation
        case windspeed10M = "windspeed_10m"
        case cloudcover
    }
}
