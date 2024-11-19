//
//  HomeViewModel.swift
//  WeatherTest
//
//  Created by Angelber Castro on 14/11/24.
//

import Combine
import Factory
import SwiftUI
import MapKit
import CoreLocation

@Observable
class MainViewModel {
    var weatherUseCase = Container.getWeatherUseCase
    var weatherDT: Coord?
    var nameLocation: String?
    var datastore = Container.datastore
    var disposables: Set<AnyCancellable> = Set()

    var locationDT: LocationData? = nil
    var selectedLocation: CLLocationCoordinate2D? = nil
    var coordinatorData: CoordinatorDt?
    var items = Container.datastore.getLocations()
    var weatherMessage: String? = nil

    func getWeather() {
        weatherUseCase.invoke()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("success")
                    self.weatherMessage = "Query completed successfully."
                case .failure(let error):
                    print("Error \(error)")
                    self.weatherMessage = "Error: \(error.localizedDescription)"
                }
            }, receiveValue: { [weak self] response in
                guard let self = self else { return }
                self.weatherDT = response.coord
                self.nameLocation = response.name

                if let lon = weatherDT?.lon, let lat = weatherDT?.lat, let name = nameLocation {
                    locationDT = LocationData(latitude: lat, longitude: lon)
                    coordinatorData = CoordinatorDt(lat: lat, lon: lon, name: name)
                }

                if let data = coordinatorData {
                    datastore.storeLocation(data)
                }

                print("\(String(describing: self.weatherDT)) and \(String(describing: self.nameLocation))")
            }).store(in: &disposables)
    }
}

struct LocationData {
    var latitude: Double
    var longitude: Double
    var initialLocation: CLLocationCoordinate2D

    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
        self.initialLocation = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
