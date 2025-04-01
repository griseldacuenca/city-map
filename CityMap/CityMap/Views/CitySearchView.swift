//
//  CitySearchView.swift
//  CityMap
//
//  Created by Griselda Cuenca on 30/03/2025.
//

import SwiftUI

struct CitySearchBarView: View {
  
  @Binding var searchTerm: String
  @Binding var noMatchesFound: Bool
  let onSearch: () async -> ()
  let onSelectedItem: (CityCellItem?) -> Void
  
  @State private var debounceTask: DispatchWorkItem? = nil

  var body: some View {
    TextField("Filter", text: $searchTerm)
      .onChange(of: searchTerm) {
        Task { await onSearch() }
      }
      .autocorrectionDisabled(true)
      .padding(10)
      .padding(.leading, 30)
      .background(Color(.systemGray6))
      .cornerRadius(8)
      .overlay(
        HStack {
          Image(systemName: "magnifyingglass")
            .foregroundColor(.gray)
            .padding(.leading, 8)
          Spacer()
          if !searchTerm.isEmpty {
            Button {
              searchTerm = ""
              onSelectedItem(nil)
              noMatchesFound = false
            } label: {
              Image(systemName: "xmark.circle.fill")
                .foregroundColor(.gray)
                .padding(.trailing, 8)
            }
          }
        }
      )
  }
}


#Preview {
  CitySearchBarView(searchTerm: .constant("Hawai"),
                    noMatchesFound: .constant(false),
                    onSearch: {},
                    onSelectedItem: {_ in })
}
