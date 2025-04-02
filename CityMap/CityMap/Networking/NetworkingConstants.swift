//
//  NetworkingConstants.swift
//  CityMap
//
//  Created by Griselda Cuenca on 30/03/2025.
//

import Foundation

struct APIConstants {
  static let citiesURL = "gist.githubusercontent.com/hernan-uala/dce8843a8edbe0b0018b32e137bc2b3a/raw/0996accf70cb0ca0e16f9a99e0ee185fafca7af1/cities.json"
}

struct FileManagerConstants {
  static let updateInterval: TimeInterval = 7 * 24 * 60 * 60 // Expiration time before refetching (e.g. 7 days)
  static let lastUpdateKey = "lastCitiesUpdateTimestamp" // Last updated timestamp stored in UserDefaults
}
