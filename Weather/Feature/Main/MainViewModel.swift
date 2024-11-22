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
class MainViewModel:  NSObject, CLLocationManagerDelegate {
    var weatherUseCase = Container.getWeatherUseCase
    var items = Container.datastore.getLocations()
    var datastore = Container.datastore
    
    var weatherDT: WeatherResponse?
    var locationDT: GeoMarker? = nil
    var coordinatorData: UserLocationData?
    
    var nameLocation: String?
    var weatherMessage: String?
    var searchText: String = ""
    
    var searchCoordinates: CLLocationCoordinate2D? = nil
    var locationManager = CLLocationManager()

    var shouldFocusOnUserLocation = true
    var isInitialLocationSet = false
 
    var disposables: Set<AnyCancellable> = Set()
  
    var currentCoordinatesText: String = "Buscando ubicación..."
    var geocoder = CLGeocoder() // Agrega el geocoder aquí
    
     override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    // Método para convertir coordenadas a nombre de lugar
       func getLocationName(for coordinates: CLLocationCoordinate2D) {
           let location = CLLocation(latitude: coordinates.latitude, longitude: coordinates.longitude)
           
           geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
               guard let self = self else { return }
               if let error = error {
                   print("Error al obtener el nombre de la ubicación: \(error)")
                   self.nameLocation = "Nombre no encontrado"
                   return
               }
               if let placemark = placemarks?.first {
                   self.nameLocation = placemark.locality ?? "Ubicación desconocida"
                   print("Nombre de la ubicación: \(self.nameLocation ?? "Sin nombre")")
               }
           }
       }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }

        if shouldFocusOnUserLocation && !isInitialLocationSet {
            locationDT = GeoMarker(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            currentCoordinatesText = String(format: "Lat: %.4f, Lon: %.4f",
                                             location.coordinate.latitude,
                                             location.coordinate.longitude)
            isInitialLocationSet = true
            
            // Llama a `getWeather` con las coordenadas obtenidas
            getWeather(lat: location.coordinate.latitude, log: location.coordinate.longitude)
            
            // Llama a `getLocationName` para obtener el nombre de la ubicación
            getLocationName(for: location.coordinate)
            
            // Detén las actualizaciones después de establecer la ubicación inicial
            locationManager.stopUpdatingLocation()
        }
    }

    func searchLocation() {
          let request = MKLocalSearch.Request()
          request.naturalLanguageQuery = searchText
          let search = MKLocalSearch(request: request)
          
          search.start { [weak self] response, error in
              guard let self = self, let mapItem = response?.mapItems.first, error == nil else {
                  self?.weatherMessage = "Location not found"
                  return
              }

              let coordinate = mapItem.placemark.coordinate
              self.searchCoordinates = coordinate

              // Actualiza `locationDT` con la nueva ubicación de búsqueda
              self.locationDT = GeoMarker(latitude: coordinate.latitude, longitude: coordinate.longitude)
              
              // Actualiza el texto de coordenadas
              self.currentCoordinatesText = String(format: "Lat: %.4f, Lon: %.4f",
                                                   coordinate.latitude,
                                                   coordinate.longitude)
              
              // Llama a `getWeather` y `getLocationName` con las coordenadas de búsqueda
              self.getWeather(lat: coordinate.latitude, log: coordinate.longitude)
              self.getLocationName(for: coordinate)
              
              // Detén las actualizaciones de ubicación automáticas para que solo se centre en el lugar buscado
              self.shouldFocusOnUserLocation = false
              self.locationManager.stopUpdatingLocation()
          }
      }

    func getWeather(lat: Double, log: Double) {
        weatherUseCase.invoke(lat: lat, log: log)
        .receive(on: DispatchQueue.main)
        .sink(receiveCompletion: { completion in
            switch completion {
            case .finished:
                print("success")
            case .failure(let error):
                print("Error \(error)")
                self.weatherMessage = "Error: \(error.localizedDescription)"
            }
        }, receiveValue: { [weak self] response in
            guard let self = self else { return }
            self.weatherDT = response
           
            if let lon = weatherDT?.longitude, let lat = weatherDT?.latitude {
                locationDT = GeoMarker(latitude: lat, longitude: lon)
                coordinatorData = UserLocationData(lat: lat, lon: lon)
            }
            if let data = coordinatorData {
                datastore.storeLocation(data)
            }

            print("\(String(describing: self.weatherDT)) and \(String(describing:self.nameLocation))")
        }).store(in: &disposables)
    }
    
    func deleteItems(at offsets: IndexSet) {
        // Eliminar cada ubicación en `UserDefaults` usando el ID
        for index in offsets {
            let item = items[index]
            Container.datastore.deleteLocation(withId: item.id)
        }
        
        // Actualizar la lista de elementos
        items = Container.datastore.getLocations()
    }
    
    func formatHour(from iso8601: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm"
        if let date = formatter.date(from: iso8601) {
            formatter.dateFormat = "HH:mm"
            return formatter.string(from: date)
        }
        return iso8601
    }
}
