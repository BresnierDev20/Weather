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
    @State private var showingCredits = false
    var body: some View {
        ZStack {
            MapView(mapViewModel: viewModel)
                .ignoresSafeArea(.all)
            
    
        }
        .onAppear {
            viewModel.getWeather()
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
        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        guard let location = mapViewModel.locationDT?.initialLocation else { return }

        // Actualiza la región del mapa
        let region = MKCoordinateRegion(
            center: location,
            span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
        )
        uiView.setRegion(region, animated: true)

        // Limpia anotaciones existentes y agrega una nueva
        uiView.removeAnnotations(uiView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = mapViewModel.nameLocation
        uiView.addAnnotation(annotation)
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
        let location = gestureRecognizer.location(in: mapView)
        let coordinate = mapView.convert(location, toCoordinateFrom: mapView)
        mapViewModel.selectedLocation = coordinate
    }
}

// Extensión para comparar coordenadas de CLLocationCoordinate2D
extension CLLocationCoordinate2D: Equatable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}
