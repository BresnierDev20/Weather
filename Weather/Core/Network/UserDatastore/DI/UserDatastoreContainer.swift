//
//  UserDatastoreContainer.swift
//  WeatherTest
//
//  Created by Angelber Castro on 16/11/24.
//

import Factory
import Foundation

extension Container {
    static var datastore: UserDatastore { UserDatastore() }
}
