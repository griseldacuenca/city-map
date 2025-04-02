//
//  CityInfoView.swift
//  CityMap
//
//  Created by Griselda Cuenca on 01/04/2025.
//

import SwiftUI

struct CityInfoView: View {
  let city: CityCellItem
  @Environment(\.dismiss) private var dismiss
  
  var body: some View {
    VStack(alignment: .leading, spacing: 16) {
      HStack {
        Text(city.title)
          .font(.largeTitle)
          .bold()
        
        Spacer()
        
        Button(action: {
          dismiss()
        }) {
          Image(systemName: "xmark.circle.fill")
            .font(.title2)
            .foregroundColor(.gray)
        }
      }
      
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
