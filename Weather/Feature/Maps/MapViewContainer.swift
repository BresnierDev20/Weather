//
//  MapViewContainer.swift
//  WeatherTest
//
//  Created by Angelber Castro on 15/11/24.
//

import SwiftUI
import MapKit

struct MapViewContainer: View {
    @State var viewModel = MainViewModel()

    var body: some View {
        ZStack {
          MapView(mapViewModel: viewModel)
            .ignoresSafeArea(.all)
            .bottomSheet(presentationDetents: [.medium, .large, .height(70)], isPresented: .constant(true), sheetCornerRadius: 20, isTransparentBG: true) {
                  VStack(alignment: .leading ) {
                      HStack {
                          Text("Clima")
                              .font(.title)
                              .fontWeight(.bold)
                          
                          Spacer()
                          
                          if let nameLocation = viewModel.nameLocation {
                              Text("Ubicación: \(nameLocation)")
                                  .font(.headline)
                                  .foregroundColor(.blue)
                          }
                           
                      }
                      .padding()
                      
                      List {
                          if let data = viewModel.weatherDT?.hourly {
                              ForEach(0..<data.time.count, id: \.self) { index in
                                 HStack {
                                     Text(viewModel.formatHour(from: data.time[index]))
                                         .font(.headline)

                                     Spacer()
                                     
                                     Text("\(data.temperature2M[index], specifier: "%.1f") °C")
                                         .font(.subheadline)
                                 }.padding(.vertical, 5)
                              }
                          }
                      }
                      Spacer()
                  }
                  .padding(.top)
                  .frame(maxWidth: .infinity, maxHeight: .infinity)
                  .background(content : {
                      Rectangle()
                          .fill(.ultraThickMaterial)
                      
                          .ignoresSafeArea()
                  })
            } onDismiss: {}
             
          VStack {
              HStack {
                  Image(systemName: "magnifyingglass")
                      .foregroundColor(.gray)
                  
                  TextField("Buscar ubicación", text: $viewModel.searchText, onCommit: {
                      viewModel.searchLocation()
                  })
                  .foregroundColor(.black)
                  .font(.system(size: 12))
                  .fontWeight(.black)
              }
              .padding(10)
              .background(
                  RoundedRectangle(cornerRadius: 5)
                      .stroke(Color.black, lineWidth: 1)
              )
              .padding(.horizontal)
              Spacer()
             
          }
          .edgesIgnoringSafeArea(.bottom)
        }
        .onAppear {
            if let location = viewModel.locationDT?.initialLocation {
                viewModel.getWeather(lat: location.latitude, log: location.longitude)
                
            }
        }
    }
}

struct MapView: UIViewRepresentable {
    @Bindable var mapViewModel: MainViewModel

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = false
        mapView.mapType = .standard
        
        // Habilitar interacción completa del usuario
        mapView.isUserInteractionEnabled = true
        mapView.setUserTrackingMode(.none, animated: false)
        
        // Añade gestos para interacción
        let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleMapTap(_:)))
        mapView.addGestureRecognizer(tapGesture)
        
        // Añade gesto de arrastre
        let panGesture = UIPanGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleMapPan(_:)))
        mapView.addGestureRecognizer(panGesture)
        
        return mapView
    }
    func updateUIView(_ uiView: MKMapView, context: Context) {
        if mapViewModel.shouldFocusOnUserLocation && mapViewModel.isInitialLocationSet {
            if let location = mapViewModel.locationDT?.initialLocation {
                let region = MKCoordinateRegion(
                    center: location,
                    span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                )
                
                // Usa setRegion con animación suave
                uiView.setRegion(region, animated: true)

                // Limpia las anotaciones previas y agrega la nueva anotación
                uiView.removeAnnotations(uiView.annotations)
                let annotation = MKPointAnnotation()
                annotation.coordinate = location
                uiView.addAnnotation(annotation)
            }
        }
        
        // Si hay una búsqueda, centramos el mapa en las coordenadas de búsqueda
        if let searchCoordinates = mapViewModel.searchCoordinates {
            let region = MKCoordinateRegion(
                center: searchCoordinates,
                span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            )
            uiView.setRegion(region, animated: true)

            // Limpia las anotaciones previas y agrega la nueva anotación
            uiView.removeAnnotations(uiView.annotations)
            let annotation = MKPointAnnotation()
            annotation.coordinate = searchCoordinates
            uiView.addAnnotation(annotation)
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(mapViewModel: mapViewModel)
    }
}

class Coordinator: NSObject, MKMapViewDelegate {
    var mapViewModel: MainViewModel

    init(mapViewModel: MainViewModel) {
        self.mapViewModel = mapViewModel
    }

    @objc func handleMapTap(_ gestureRecognizer: UITapGestureRecognizer) {
        guard let mapView = gestureRecognizer.view as? MKMapView else { return }
        
        // Desactiva el seguimiento automático
        mapViewModel.shouldFocusOnUserLocation = false
        mapViewModel.isInitialLocationSet = false
        
        // Detén las actualizaciones de ubicación
        mapViewModel.locationManager.stopUpdatingLocation()
    }
    
    @objc func handleMapPan(_ gestureRecognizer: UIPanGestureRecognizer) {
        // Desactiva el seguimiento automático cuando se arrastra el mapa
        mapViewModel.shouldFocusOnUserLocation = false
        mapViewModel.isInitialLocationSet = false
        mapViewModel.locationManager.stopUpdatingLocation()
    }
}
