//
//  CityNavigationView.swift
//  CityMap
//
//  Created by Griselda Cuenca on 30/03/2025.
//

import SwiftUI

struct CityNavigationView: View {
  @State private var selectedCity: City?
  
//  let cities = [
//    City(name: "Hurzuf", country: "UA", latitude: 44.549999, longitude: 34.283333, isFavorite: false),
//    City(name: "Sydney", country: "AU", latitude: -33.8688, longitude: 151.2093, isFavorite: true)
//  ]
  
  var body: some View {
    EmptyView()
//    NavigationStack {
//      List(cities) { city in
//        CityCellView(city: city, selectedCity: $selectedCity)
//      }
//      .navigationTitle("Cities")
//      .navigationDestination(item: $selectedCity) { city in
//        MapView(city: city)
//      }
//    }
  }
}
