//
//  ContentView.swift
//  CityMap
//
//  Created by Griselda Cuenca on 28/03/2025.
//

import SwiftUI

struct CityListView: View {
  
  @StateObject var vm = CityListViewModel(dependencies: .init(getCitiesUseCase: GetCitiesUseCase()))
  
  var body: some View {
    NavigationStack {
      if vm.isInitialLoading {
        VStack {
          Spacer()
          ProgressView("Initializing the app...")
          Spacer()
        }
        .onAppear {
          Task { await vm.handleOnAppear() }
        }
      } else {
        VStack {
          CitySearchBarView(
            isLoading: vm.isLoading,
            searchTerm: $vm.searchTerm,
            noMatchesFound: $vm.noMatchesFound,
            onSearch: { Task { await vm.onSearch() }},
            onSelectedItem: vm.onSelectedCity
          )
          
          Toggle("Search Favorites Only", isOn: $vm.searchFavoritesOnly)
            .padding(.horizontal)
          
          ScrollView {
            LazyVStack(spacing: 8) {
              if vm.noMatchesFound {
                ContentUnavailableView.search
              } else {
                ForEach(vm.viewContent.indices, id: \.self) { index in
                  NavigationLink(destination: CityMapView(city: vm.viewContent[index])) {
                    CityCellView(
                      city: vm.viewContent[index],
                      onToggleFavorite: {
                        vm.handleOnToggleFavorite(with: index)
                      }
                    )
                  }
                }
              }
            }
          }
          
          Spacer()
        }
        .padding(.horizontal, 10)
        .navigationDestination(for: CityCellItem.self) { result in
          CityMapView(city: result)
        }
      }
    }
  }
}

#Preview("WithData") {
  CityListView(vm: CityListViewModel(dependencies: .init(getCitiesUseCase: MockGetCitiesUseCase()),
                                     viewContent: [.init(id: 123,
                                                         title: "Buenos Aires, AR",
                                                         subtitle: "Long: -78.497498, Lat: -9.12417",
                                                         isFavorite: false,
                                                         lat: -9.12417,
                                                         lon: -78.497498)]))
}

#Preview("EmptyState") {
  CityListView(vm: CityListViewModel(dependencies: .init(getCitiesUseCase: MockGetCitiesUseCase()),
                                     viewContent: []))
}
