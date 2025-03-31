//
//  SearchBarView.swift
//  CityMap
//
//  Created by Griselda Cuenca on 28/03/2025.
//

import SwiftUI

struct SearchBarView: View {
  
  @Binding var searchTerm: String
  let placeholder: String
  let results: [CityCellItem]
  @Binding var noMatchesFound: Bool
  let isLoading: Bool
  let onSearch: () -> Void
  let onSelectedItem: (CityCellItem?) -> Void
  let previousSelection: String?
  
  var body: some View {
    VStack {
      TextField(placeholder, text: $searchTerm)
        .onChange(of: searchTerm) {
          if searchTerm != previousSelection {
            Task {
              noMatchesFound = false
              onSearch()
            }
          }
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
            if isLoading {
              ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: Color(.systemBlue)))
                .frame(width: 20, height: 20)
                .padding(.trailing, 16)
            } else if !searchTerm.isEmpty {
              Button {
                searchTerm = ""
                onSelectedItem(nil)
              } label: {
                Image(systemName: "xmark.circle.fill")
                  .foregroundColor(.gray)
                  .padding(.trailing, 8)
              }
            }
          }
        )
      
      LazyVStack(spacing: 8)  {
        if noMatchesFound {
          Text("No results found. Please refine your search.")
            .frame(maxWidth: .infinity, alignment: .leading)
        } else {
          ForEach(results) { result in
            Text(result.title)
              .frame(maxWidth: .infinity, alignment: .leading)
              .onTapGesture {
                searchTerm = result.title
                onSelectedItem(result)
              }
          }
        }
      }
    }
    .padding(.horizontal, 10)
  }
}

#Preview {
  SearchBarView(searchTerm: .constant(""),
                placeholder: "Search...",
                results: [.init(id: 1, title: "Denver, US", subtitle: "Long: 24.28. Lat: 44.54", isFavorite: false),
                          .init(id: 2, title: "Denver, US", subtitle: "Long: 24.28. Lat: 44.54", isFavorite: false),
                          .init(id: 3, title: "Denver, US", subtitle: "Long: 24.28. Lat: 44.54", isFavorite: false),
                          .init(id: 4, title: "Denver, US", subtitle: "Long: 24.28. Lat: 44.54", isFavorite: false),
                          .init(id: 5, title: "Denver, US", subtitle: "Long: 24.28. Lat: 44.54", isFavorite: false)],
                noMatchesFound: .constant(false),
                isLoading: false,
                onSearch: {},
                onSelectedItem: {_ in },
                previousSelection: nil)
}
