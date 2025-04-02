//
//  CityCellView.swift
//  CityMap
//
//  Created by Griselda Cuenca on 30/03/2025.
//

import SwiftUI

struct CityCellView: View {
  
  let city: CityCellItem
  let onToggleFavorite: () -> Void
  
  var body: some View {
    HStack {
      VStack(alignment: .leading) {
        Text("\(city.title)")
          .font(.headline)
        
        Text(city.subtitle)
          .font(.subheadline)
          .foregroundColor(.gray)
      }
      Spacer()
      
      Button(action: {
        onToggleFavorite()
      }) {
        Image(systemName: city.isFavorite ? "star.fill" : "star")
          .foregroundColor(city.isFavorite ? .blue : .gray)
      }
    }
    .padding()
    .shadow(radius: 1)
  }
}

#Preview {
  CityCellView(city: .init(id: 123,
                           title: "Strathmore, CA",
                           subtitle: "Lat: 51.05011, Lon: -113.385231",
                           isFavorite: false,
                           lat: 44.54,
                           lon: 24.28),
               onToggleFavorite: {})
}
