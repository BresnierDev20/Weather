//
//  LocationsRow.swift
//  WeatherTest
//
//  Created by Angelber Castro on 15/11/24.
//

import SwiftUI

struct LocationsRow: View {
    var lat: Double
    var lon: Double
 
    var body: some View {
        HStack {
            // Icono de globo
            Image(systemName: "globe")
                .foregroundColor(.orange)
                .font(.system(size: 24))

            // Detalles de la ciudad
            VStack(alignment: .leading) {

                Text("Coordinates: \(lat) / \(lon)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }

            Spacer()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}
