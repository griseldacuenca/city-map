//
//  CityListViewModel.swift
//  CityMap
//
//  Created by Griselda Cuenca on 28/03/2025.
//

import SwiftUI
import Combine

final class CityListViewModel: ObservableObject {
  
  @Published var isLoading: Bool = false
  @Published var isInitialLoading: Bool = true
  @Published var searchTerm: String = ""
  @Published var viewContent: [CityCellItem] = []
  @Published var noMatchesFound: Bool = false

  @Published var cities: [City] = []
  @Published var filteredCities: [City] = []
  @Published var showFavoritesOnly = false
  
  // In-memory cache for favorite cities
  @AppStorage("favoriteCities") private var favoriteCityIDs = ""
  @Published var favoriteCities: Set<Int> = []
  
  @Published var onSelectedItem: CityCellItem?
  @Published var previousSelection: String?
  
  private let dependencies: Dependencies
  private var prefixTrie = PrefixTrie()
  private var task: Task<Void, Never>?
  
  struct Dependencies {
    var getCitiesUseCase: GetCitiesUseCaseProtocol
  }
  
  init(dependencies: Dependencies, viewContent: [CityCellItem] = []) {
    self.dependencies = dependencies
    self.viewContent = viewContent
  }
  
  func handleOnAppear() async {
    if viewContent.isEmpty {
      await fetchCities()
    }
  }
  
  @MainActor
  func onSearch() async {
    guard !searchTerm.isEmpty else {
//      viewContent = []
      return
    }
    print("searchTerm: \(searchTerm)")
//     await fetchCities()
    self.filterCitiesData(with: self.searchTerm, favoritesOnly: self.showFavoritesOnly)
  }
  
  @MainActor
  private func fetchCities() async {
    do {
      isInitialLoading = true
      let result = try await dependencies.getCitiesUseCase.execute(url: APIConstants.citiesURL)
      await processCities(result)
      
      let cities = filterCities(with: searchTerm, content: result)
      viewContent = transformCitiesToCellItems(cities)
      if viewContent.isEmpty {
        noMatchesFound = true
      } else {
        noMatchesFound = false
      }
      isInitialLoading = false
    } catch {
      isInitialLoading = false
      debugPrint("Unable to fetch cities")
      // Add a snackbar with the error
    }
  }
  
  private func processCities(_ cities: [City]) async {
    // Process on a background thread
    let sortedCities = cities.sorted { $0.name < $1.name }
    
    // Build the prefix trie
    let trie = PrefixTrie()
    for (index, city) in sortedCities.enumerated() {
      trie.insert(word: city.name.lowercased(), index: index)
    }
    
    // Update on the main thread
    await MainActor.run {
      self.cities = sortedCities
      self.prefixTrie = trie
//      self.filterCitiesData(with: self.searchTerm, favoritesOnly: self.showFavoritesOnly)
      self.isLoading = false
    }
  }
  
  private func performFiltering(prefix: String, favoritesOnly: Bool) async {
    // Handle empty prefix case
    let matchingCities: [City]
    
    await MainActor.run {
      isLoading = true
    }
    
    if prefix.isEmpty {
      // No search text, show all cities or just favorites
      matchingCities = favoritesOnly ? cities.filter { favoriteCities.contains($0.id) } : cities
    } else {
      // Find matching indices using the trie
      let matchIndices = prefixTrie.findIndices(with: prefix.lowercased())
      
      // Map indices back to cities
      matchingCities = matchIndices.compactMap { index -> City? in
        guard index < cities.count else { return nil }
        let city = cities[index]
        return favoritesOnly ? (favoriteCities.contains(city.id) ? city : nil) : city
      }
    }
    
    // Update on the main thread
    await MainActor.run {
      self.filteredCities = matchingCities
      // Transform to cityView:
      viewContent = transformCitiesToCellItems(self.filteredCities)
      if viewContent.isEmpty {
        noMatchesFound = true
      } else {
        noMatchesFound = false
      }
      isLoading = false
    }
  }
  
  func filterCitiesData(with prefix: String, favoritesOnly: Bool) {
    // Cancel any previous task to ensure UI responsiveness
    task?.cancel()
    
    task = Task {
      await performFiltering(prefix: prefix, favoritesOnly: favoritesOnly)
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
