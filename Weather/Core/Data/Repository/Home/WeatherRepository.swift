//
//  WeatherRepository.swift
//  WeatherTest
//
//  Created by Angelber Castro on 14/11/24.
//

import Combine

protocol WeatherRepository {
    func getWeather() -> AnyPublisher<WeatherResponse, ServiceErrors>
}
