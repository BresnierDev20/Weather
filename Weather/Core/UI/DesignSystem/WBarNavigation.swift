//
//  WBarNavigation.swift
//  Weather
//
//  Created by Bresnier Moreno on 21/11/24.
//

import SwiftUI

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

