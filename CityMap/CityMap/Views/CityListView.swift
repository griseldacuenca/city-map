//
//  CityListView.swift
//  CityMap
//
//  Created by Griselda Cuenca on 01/04/2025.
//

import SwiftUI

struct CityListView: View {
  @ObservedObject var vm: CityListViewModel
  @Binding var selectedCity: CityCellItem?
  let orientation: UIDeviceOrientation
  
  var body: some View {
    Group {
      if vm.isInitialLoading {
        VStack {
          Spacer()
          ProgressView("Initializing the app...")
            .progressViewStyle(CircularProgressViewStyle(tint: Color(.systemBlue)))
          Spacer()
        }
        .onAppear {
          Task { await vm.handleOnAppear() }
        }
      } else {
        VStack {
          CitySearchBarView(
            searchTerm: $vm.searchTerm,
            noMatchesFound: $vm.noMatchesFound,
            onSearch: { Task { await vm.onSearch() }},
            onSelectedItem: { city in
              selectedCity = city
            }
          )
          .padding(.top, 8)
          
          Toggle("Search Favorites Only", isOn: $vm.searchFavoritesOnly)
            .padding(.horizontal)
          
          ScrollView {
            LazyVStack(spacing: 8) {
              if vm.noMatchesFound {
                ContentUnavailableView.search
              } else {
                ForEach(vm.viewContent.indices, id: \.self) { index in
                  let city = vm.viewContent[index]
                  let isSelected = selectedCity?.id == city.id
                  
                  // Determine if we're using NavigationLink or just a button based on orientation
                  Group {
                    if orientation.isPortrait || orientation == .unknown {
                      NavigationLink(destination: CityMapView(city: city)) {
                        cityCell(for: index)
                          .cellBackground(index: index)
                      }
                    } else {
                      cityCell(for: index)
                        .onTapGesture {
                          selectedCity = city
                        }
                        .cellBackground(index: index, isSelected: isSelected)
                    }
                  }
                }
              }
            }
          }
          
          Spacer()
        }
        .padding(.horizontal, 10)
      }
    }
  }
  
  private func cityCell(for index: Int) -> some View {
    CityCellView(
      city: vm.viewContent[index],
      onToggleFavorite: {
        vm.handleOnToggleFavorite(with: index)
      }
    )
  }
}
