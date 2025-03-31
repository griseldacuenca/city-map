//
//  SearchBarItem.swift
//  CityMap
//
//  Created by Griselda Cuenca on 28/03/2025.
//

struct CityCellItem: Identifiable, Hashable {
  let id: Int
  let title: String
  let subtitle: String
  var isFavorite: Bool
}
