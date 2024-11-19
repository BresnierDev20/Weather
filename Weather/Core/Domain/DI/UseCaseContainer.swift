//
//  UseCaseContainer.swift
//  WeatherTest
//
//  Created by Angelber Castro on 14/11/24.
//

import Factory

extension Container {
    static var getWeatherUseCase: WeatherUseCase { WeatherUseCase() }
}
