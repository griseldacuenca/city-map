//
//  CitySearchView.swift
//  CityMap
//
//  Created by Griselda Cuenca on 30/03/2025.
//

import SwiftUI

struct CitySearchBarView: View {

  let isLoading: Bool
  @Binding var searchTerm: String
  let previousSelection: String?
  let onSearch: () async -> ()
  let onSelectedItem: (CityCellItem?) -> Void
  
  @State private var debounceTask: DispatchWorkItem? = nil

  var body: some View {
    TextField("Filter", text: $searchTerm)
      .onChange(of: searchTerm) {
        if searchTerm != previousSelection {
          debounceTask?.cancel()
          
          let task = DispatchWorkItem {
            Task { await onSearch() }
          }
          
          debounceTask = task
          DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            task.perform()
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
}


#Preview {
  CitySearchBarView(isLoading: false,
                    searchTerm: .constant("Hawai"),
                    previousSelection: nil,
                    onSearch: {},
                    onSelectedItem: {_ in })
}
