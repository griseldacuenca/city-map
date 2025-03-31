//
//  CityListViewModel.swift
//  CityMap
//
//  Created by Griselda Cuenca on 28/03/2025.
//

import Foundation

@MainActor final class CityListViewModel: ObservableObject {
  
  @Published var isLoading: Bool = false
  @Published var searchTerm: String = ""
  @Published var viewContent: [CityCellItem] = []
  @Published var noMatchesFound: Bool = false
  @Published var cityList: [City] = []
  @Published var onSelectedItem: CityCellItem?
  @Published var previousSelection: String?
  
  private let dependencies: Dependencies
  private let waitHalfSecond: UInt64 = 500_000_000
  
  struct Dependencies {
    var getCitiesUseCase: GetCitiesUseCaseProtocol
  }
  
  init(dependencies: Dependencies) {
    self.dependencies = dependencies
  }
  
  private func fetchCities() async {
    do {
      isLoading = true
      let result = try await dependencies.getCitiesUseCase.execute(url: APIConstants.citiesURL)
      let cities = filterCities(with: searchTerm, content: result)
      viewContent = transformCitiesToCellItems(cities)
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
        id: city.id,
        title: "\(city.name), \(city.country)",
        subtitle: "Lat: \(city.coord.lat), Lon: \(city.coord.lon)",
        isFavorite: false
      )
    }
  }

  
  @MainActor
  func onSearch() async {
    try? await Task.sleep(nanoseconds: waitHalfSecond)
    if searchTerm.isEmpty {
      viewContent = []
      if searchTerm.isEmpty {
        // subjectSelected = ""
      }
    } else {
      await fetchCities()
    }
  }

  func filterCities(with prefix: String, content: [City]) -> [City] {
    return content.filter { $0.name.lowercased().hasPrefix("Ciudad".lowercased()) }
  }
  
  private func getInitialContent() -> [CityCellItem] {
    return [.init(id: 1, title: "Denver, US", subtitle: "Long: 24.28. Lat: 44.54", isFavorite: false),
            .init(id: 2, title: "Denver, US", subtitle: "Long: 24.28. Lat: 44.54", isFavorite: false),
            .init(id: 3, title: "Denver, US", subtitle: "Long: 24.28. Lat: 44.54", isFavorite: false),
            .init(id: 4, title: "Denver, US", subtitle: "Long: 24.28. Lat: 44.54", isFavorite: false),
            .init(id: 5, title: "Denver, US", subtitle: "Long: 24.28. Lat: 44.54", isFavorite: false),
            .init(id: 6, title: "Denver, US", subtitle: "Long: 24.28. Lat: 44.54", isFavorite: false),
            .init(id: 7, title: "Denver, US", subtitle: "Long: 24.28. Lat: 44.54", isFavorite: false),
            .init(id: 8, title: "Denver, US", subtitle: "Long: 24.28. Lat: 44.54", isFavorite: false),
            .init(id: 9, title: "Denver, US", subtitle: "Long: 24.28. Lat: 44.54", isFavorite: false),
            .init(id: 10, title: "Denver, US", subtitle: "Long: 24.28. Lat: 44.54", isFavorite: false),
            .init(id: 11, title: "Denver, US", subtitle: "Long: 24.28. Lat: 44.54", isFavorite: false)]
  }
}
