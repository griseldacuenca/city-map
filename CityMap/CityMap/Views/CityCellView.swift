//
//  CityCellView.swift
//  CityMap
//
//  Created by Griselda Cuenca on 30/03/2025.
//

import SwiftUI

struct CityCellView: View {
  
  @State var city: CityCellItem
  @Binding var selectedCity: CityCellItem?
  
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
        city.isFavorite.toggle()
      }) {
        Image(systemName: city.isFavorite ? "star.fill" : "star")
          .foregroundColor(city.isFavorite ? .blue : .gray)
      }
    }
    .padding()
    .background(Color(.systemBackground))
    .shadow(radius: 1)
    .onTapGesture {
      selectedCity = city
    }
  }
}

#Preview {
  CityCellView(city: .init(id: 123, title: "Strathmore, CA", subtitle: "Lat: 51.05011, Lon: -113.385231", isFavorite: false),
               selectedCity: .constant(nil))
}
