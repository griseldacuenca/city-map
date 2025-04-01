//
//  CityInfoView.swift
//  CityMap
//
//  Created by Griselda Cuenca on 01/04/2025.
//

import SwiftUI

struct CityInfoView: View {
  let city: CityCellItem
  
  var body: some View {
    VStack(alignment: .leading, spacing: 16) {
      Text(city.title)
        .font(.largeTitle)
        .bold()
      
      Divider()
      
      Group {
        Text("Coordinates")
          .font(.headline)
        Text("Latitude: \(city.lat)")
        Text("Longitude: \(city.lon)")
      }
      
      Spacer()
    }
    .padding()
  }
}

#Preview {
  CityInfoView(city: .init(id: 123,
                           title: "Denver, US",
                           subtitle: "Long: 24.28. Lat: 44.54",
                           isFavorite: false,
                           lat: 44.54,
                           lon: 24.28))
}
