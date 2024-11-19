//
//  WeatherRemoteDtaSourceImpl.swift
//  WeatherTest
//
//  Created by Angelber Castro on 14/11/24.
//

import Alamofire
import Foundation
import Combine

class WeatherRemoteDataSourceImpl: WeatherRemoteDataSource {
    func getWeather() -> AnyPublisher<WeatherResponse, ServiceErrors> {
        let url = URLDomains.shared.BASE + URLDomains.shared.EndpointWeather
        let headers: HTTPHeaders = ["x-rapidapi-key": "\(URLDomains.shared.ApiKey)", "x-rapisapi-host":"\(URLDomains.shared.ApiKey)"]

        return AF.request(url, method: .get, headers: headers)
            .publishData()
            .tryMap { dataResponse -> Data in
                guard let statusCode = dataResponse.response?.statusCode else {
                    throw URLError(.badServerResponse)
                }
                if 200..<300 ~= statusCode {
                    return dataResponse.data ?? Data()
                } else {
                    throw ServiceErrors.apiError(statusCode, dataResponse.data ?? Data())
                }
            }
            .decode(type: WeatherResponse.self, decoder: JSONDecoder())
            .mapError { error -> ServiceErrors in
                return ErrorHandler.handleError(error)
            }
            .eraseToAnyPublisher()
    }
}
