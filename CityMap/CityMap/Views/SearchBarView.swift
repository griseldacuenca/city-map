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
    }
    .padding(.horizontal, 10)
  }
}

#Preview {
  SearchBarView(searchTerm: .constant(""),
                placeholder: "Search...",
                noMatchesFound: .constant(false),
                isLoading: false,
                onSearch: {},
                onSelectedItem: {_ in },
                previousSelection: nil)
}
