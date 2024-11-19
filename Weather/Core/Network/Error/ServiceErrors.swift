//
//  ServiceErrors.swift
//  WeatherTest
//
//  Created by Angelber Castro on 14/11/24.
//

import Foundation

class ErrorHandler {
    static func handleError(_ error: Error) -> ServiceErrors {
        if let serviceError = error as? ServiceErrors {
            return serviceError
        }
        return .customMessage("Se produjo un error con el servidor")
    }
}

enum ServiceErrors: Error {
    case apiError(Int, Data)
    case networkError
    case decodingError
    case customMessage(String)

    var localizedDescription: String {
        switch self {
        case .apiError:
            return "Hubo un problema al comunicarse con el servidor."
        case .networkError:
            return "Error de red. Intentalo mas tarde"
        case .decodingError:
            return "Error al procesar la respuesta del servidor. Intentalo mas tarde"
        case .customMessage(let message):
            return message
        }
    }
}
