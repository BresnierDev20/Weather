//
//  ButtonStyle.swift
//  WeatherTest
//
//  Created by Angelber Castro on 15/11/24.
//

import SwiftUI

// Estilo para los botones en MainView
struct ButtonsStyle: ButtonStyle {
    var color: Color
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .frame(maxWidth: .infinity)
            .background(color)
            .foregroundColor(.white)
            .cornerRadius(10)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}
