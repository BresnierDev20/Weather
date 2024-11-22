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
    func getWeather(lat: Double, log: Double) -> AnyPublisher<WeatherResponse, ServiceErrors> {
        let url = URLDomains.shared.BASE + URLDomains.shared.EndpointWeather
       
        let parameters: [String: Any] = [
            "latitude": lat,
            "longitude": log,
            "hourly": "temperature_2m,precipitation,windspeed_10m,cloudcover"
        ]
        
        let header: HTTPHeaders = [
            "x-rapidapi-key":"ebc04bcc90msh3843ce42ca972a9p14020djsn250387630867",
            "x-rapisapi-host":"open-weather13.p.rapidapi.com"
        ]
        
        return AF.request(url, method: .get, parameters: parameters, headers: header )
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
