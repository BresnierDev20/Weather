//
//  NetworkContainer.swift
//  WeatherTest
//
//  Created byAngelber Castro on 14/11/24.
//

import Factory

extension Container {
    static var WeatherRemoteDataSource: WeatherRemoteDataSource { WeatherRemoteDataSourceImpl() as WeatherRemoteDataSource }
}
