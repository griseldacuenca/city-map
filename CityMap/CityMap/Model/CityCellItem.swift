//
//  SearchBarItem.swift
//  CityMap
//
//  Created by Griselda Cuenca on 28/03/2025.
//

import Foundation

struct CityCellItem: Identifiable, Hashable {
  let id: UUID = UUID()
  let title: String
  let subtitle: String
  var isFavorite: Bool
  let lat: Double
  let lon: Double
}
