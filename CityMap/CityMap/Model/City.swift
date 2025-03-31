//
//  City.swift
//  CityMap
//
//  Created by Griselda Cuenca on 28/03/2025.
//

import Foundation

struct City: Codable, Identifiable {
  let country: String
  let name: String
  let id: Int
  let coord: Coordinates
  
  enum CodingKeys: String, CodingKey {
    case country
    case name
    case id = "_id"
    case coord
  }
  
  static let mock = City(country: "IT",
                         name: "Arese",
                         id: 6541492,
                         coord: .init(lon: 9.07654,
                                      lat: 45.552269))
}

struct Coordinates: Codable {
  let lon: Double
  let lat: Double
}
