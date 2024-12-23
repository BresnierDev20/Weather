//
//  WeatherUseCase.swift
//  WeatherTest
//
//  Created by Angelber Castro on 14/11/24.
//

import Factory
import Combine

class WeatherUseCase {
    var repo = Container.weatherRepository

    func invoke(lat: Double, log: Double) -> AnyPublisher<WeatherResponse, ServiceErrors> {
        return repo.getWeather(lat: lat, log: log)
    }
}
