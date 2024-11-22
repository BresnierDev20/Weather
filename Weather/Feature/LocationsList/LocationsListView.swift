//
//  LocationsListView.swift
//  WeatherTest
//
//  Created by Bresnier Moreno 15/11/24.
//

import SwiftUI
import Factory

struct LocationsListView: View {
    @Environment(\.presentationMode) var presentationMode
    var viewModel: MainViewModel
    var items = Container.datastore.getLocations()
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
                            .padding(.top)

                        List {
                            ForEach(items) { item in
                                LocationsRow(lat: item.lat, lon: item.lon)
                                    .listRowInsets(EdgeInsets(top: 0, leading: 10, bottom: 5, trailing: 10))
                                    .listRowBackground(Color.white.opacity(0.1))
                            }
                            .onDelete(perform: viewModel.deleteItems)
                            
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
}
