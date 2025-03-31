//
//  CityListViewModel.swift
//  CityMap
//
//  Created by Griselda Cuenca on 28/03/2025.
//

import Foundation
import MapKit

@MainActor
final class CityListViewModel: ObservableObject {
  
  @Published var isLoading: Bool = false
  @Published var searchTerm: String = ""
  @Published var viewContent: [CityCellItem] = []
  @Published var noMatchesFound: Bool = false
  @Published var cityList: [City] = []
  @Published var onSelectedItem: CityCellItem?
  @Published var previousSelection: String?
  
  private let dependencies: Dependencies
  
  struct Dependencies {
    var getCitiesUseCase: GetCitiesUseCaseProtocol
  }
  
  init(dependencies: Dependencies, viewContent: [CityCellItem] = []) {
    self.dependencies = dependencies
    self.viewContent = viewContent
  }
  
  @MainActor
  func onSearch() async {
    guard !searchTerm.isEmpty else {
      viewContent = []
      return
    }
    print("searchTerm: \(searchTerm)")
     await fetchCities()
  }
  
  @MainActor
  private func fetchCities() async {
    do {
      isLoading = true
      let result = try await dependencies.getCitiesUseCase.execute(url: APIConstants.citiesURL)
      let cities = filterCities(with: searchTerm, content: result)
      viewContent = transformCitiesToCellItems(cities)
      if viewContent.isEmpty {
        noMatchesFound = true
      } else {
        noMatchesFound = false
      }
      isLoading = false
    } catch {
      isLoading = false
      debugPrint("Unable to fetch cities")
      // Add a snackbar with the error
    }
  }
  
  func onSelectedCity(_ city: CityCellItem?) {
    
  }
  
  private func transformCitiesToCellItems(_ cities: [City]) -> [CityCellItem] {
    return cities.map { city in
      CityCellItem(
        title: "\(city.name), \(city.country)",
        subtitle: "Lat: \(city.coord.lat), Lon: \(city.coord.lon)",
        isFavorite: false,
        lat: city.coord.lat,
        lon: city.coord.lon
      )
    }
  }

  func filterCities(with prefix: String, content: [City]) -> [City] {
    return content.filter { $0.name.lowercased().hasPrefix(prefix.lowercased()) }
  }
}
