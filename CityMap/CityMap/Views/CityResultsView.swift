//
//  CityResultsView.swift
//  CityMap
//
//  Created by Griselda Cuenca on 30/03/2025.
//

import SwiftUI

struct CityResultsView: View {
  
  let noMatchesFound: Bool
  let results: [CityCellItem]
  @Binding var onSelectedItem: CityCellItem?
  
  var body: some View {
    LazyVStack(spacing: 8) {
      if noMatchesFound {
        Text("No results found. Please refine your search.")
          .frame(maxWidth: .infinity, alignment: .leading)
      } else {
        ForEach(results) { result in
          CityCellView(city: .init(id: result.id,
                                   title: result.title,
                                   subtitle: result.subtitle,
                                   isFavorite: result.isFavorite),
                       selectedCity: $onSelectedItem)
          .onTapGesture {
//            vm.searchTerm = result.title
            onSelectedItem = result
          }
        }
      }
    }
  }
}

#Preview {
  CityResultsView(noMatchesFound: false,
                  results: [.init(id: 1, title: "Denver, US", subtitle: "Long: 24.28. Lat: 44.54", isFavorite: false),
                            .init(id: 2, title: "Denver, US", subtitle: "Long: 24.28. Lat: 44.54", isFavorite: false),
                            .init(id: 3, title: "Denver, US", subtitle: "Long: 24.28. Lat: 44.54", isFavorite: false),
                            .init(id: 4, title: "Denver, US", subtitle: "Long: 24.28. Lat: 44.54", isFavorite: false),
                            .init(id: 5, title: "Denver, US", subtitle: "Long: 24.28. Lat: 44.54", isFavorite: false)],
                  onSelectedItem: .constant(nil))
}
