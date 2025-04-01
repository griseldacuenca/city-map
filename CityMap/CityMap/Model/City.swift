//
//  City.swift
//  CityMap
//
//  Created by Griselda Cuenca on 28/03/2025.
//

import Foundation

struct City: Codable, Identifiable {
  let id: Int
  let name: String
  let country: String
  let coord: Coordinates
  
  enum CodingKeys: String, CodingKey {
    case country
    case name
    case id = "_id"
    case coord
  }
  
  static let mock = City(id: 6541492,
                         name: "Arese",
                         country: "IT",
                         coord: .init(lon: 9.07654,
                                      lat: 45.552269))
}

struct Coordinates: Codable {
  let lon: Double
  let lat: Double
}
