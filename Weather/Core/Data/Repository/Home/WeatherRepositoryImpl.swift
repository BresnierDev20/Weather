//
//  WeatherRepositoryImpl.swift
//  WeatherTest
//
//  Created by Angelber Castro on 14/11/24.
//

import Combine
import Factory

class WeatherRepositoryImpl: WeatherRepository {
    var remote = Container.WeatherRemoteDataSource
    
    func getWeather() -> AnyPublisher<WeatherResponse, ServiceErrors> {
        remote.getWeather()
    }
}
