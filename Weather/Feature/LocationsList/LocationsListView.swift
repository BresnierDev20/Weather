//
//  LocationsListView.swift
//  WeatherTest
//
//  Created by Bresnier Moreno 15/11/24.
//

import SwiftUI
import Factory

struct LocationsListView: View {
    @State var items = Container.datastore.getLocations()
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(spacing: 0) {
            topBar
            
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color.gray.opacity(0.3), Color.gray]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                VStack(alignment: .leading) {
                    if items.count > 0 {
                        Text("My Locations")
                            .font(.largeTitle)
                            .bold()
                            .padding(.horizontal)

                        List {
                            ForEach(items) { item in
                                LocationsRow(lat: item.lat, lon: item.lon, name: item.name)
                                    .listRowInsets(EdgeInsets(top: 0, leading: 10, bottom: 5, trailing: 10))
                                    .listRowBackground(Color.white.opacity(0.1))
                            }
                            .onDelete(perform: deleteItems)
                            
                        }
                        .listStyle(PlainListStyle())
                        
                        
                    } else {
                        Spacer()
                        Text("Empty locations")
                            .font(.largeTitle)
                            .bold()
                            .padding(.horizontal)
                        Spacer()
                    }
                }
            }
            .ignoresSafeArea(.all)
        }
        .navigationBarHidden(true)
    }
    
    var topBar: some View {
        WBarNavigation {
            presentationMode.wrappedValue.dismiss()
        }
    }
    // Función para manejar la eliminación de elementos
        func deleteItems(at offsets: IndexSet) {
            // Eliminar cada ubicación en `UserDefaults` usando el ID
            for index in offsets {
                let item = items[index]
                Container.datastore.deleteLocation(withId: item.id)
            }
            
            // Actualizar la lista de elementos
            items = Container.datastore.getLocations()
        }
}


struct WBarNavigation: View {
    var onDismiss:  (() -> Void)
    
    var body: some View {
        VStack(spacing: Constants.spacing) {
            HStack {
                Image(Imagen.arrowBack)
                    .resizable()
                    .scaledToFill()
                    .frame(width: Constants.imageWidth, height: Constants.imageHeight)
                    .foregroundColor(Color.black)
                    .onTapGesture {
                        onDismiss()
                    }
                
                Text("Salir")
                    .foregroundColor(Color.black)
                
                Spacer()
            }
            .padding(.bottom, Constants.paddingBottom)
            .padding(.horizontal)
        }
        .frame(maxWidth: .infinity)
        .frame(height: Constants.height)
        .background(Color.white)
    }
}

extension WBarNavigation {
    class Constants {
        static let spacing: CGFloat = 0
        static let imageWidth: CGFloat = 14
        static let imageHeight: CGFloat = 14
        static let height: CGFloat = 40
        static let paddingBottom: CGFloat = 20
    }
}

class Imagen {
    static let arrowBack = "arrow_back_symbol"
}

extension Image {
    func renderIcon() -> some View {
      return self
        .resizable()
        .scaledToFit()
    }
}

