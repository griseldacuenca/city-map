//
//  CityListViewModel.swift
//  CityMap
//
//  Created by Griselda Cuenca on 28/03/2025.
//

import SwiftUI
import Combine

final class CityListViewModel: ObservableObject {
  
  @Published var isInitialLoading: Bool = true
  @Published var searchTerm: String = ""
  @Published var viewContent: [CityCellItem] = []
  @Published var noMatchesFound: Bool = false
  
  @Published var cities: [City] = []
  @Published var filteredCities: [City] = []
  @Published var searchFavoritesOnly = false {
    didSet {
      // When favorites toggle changes, reapply the current search filter
      Task {
        await filterCitiesData(with: searchTerm, favoritesOnly: searchFavoritesOnly)
      }
    }
  }
  
  // In-memory cache for favorite cities
  @AppStorage("favoriteCities") private var favoriteCityIDs = "" // Stored as a comma-separated string
  @Published var favoriteCities: Set<Int> = []
  
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
    
    // Load saved favorite city IDs from @AppStorage
    let intIDs = favoriteCityIDs.split(separator: ",").compactMap { Int($0) }
    self.favoriteCities = Set(intIDs)
  }
  
  func handleOnAppear() async {
    if viewContent.isEmpty {
      await fetchCities()
    }
  }
  
  func handleOnToggleFavorite(with index: Int) {
    guard index < viewContent.count else { return }
    
    viewContent[index].isFavorite.toggle()
    
    let cityID = viewContent[index].id
    
    if viewContent[index].isFavorite {
      favoriteCities.insert(cityID)
    } else {
      favoriteCities.remove(cityID)
    }
    
    // Save back to @AppStorage as comma-separated Ints
    favoriteCityIDs = favoriteCities.map { String($0) }.joined(separator: ",")
    
    // If we're in favorites only mode and we just unfavorited a city,
    // we need to refresh the list to remove it
    if searchFavoritesOnly {
      Task {
        await filterCitiesData(with: searchTerm, favoritesOnly: true)
      }
    }
  }
  
  
  @MainActor
  func onSearch() async {
    if searchTerm.isEmpty {
      // When search term is empty, show all cities or favorites, sorted alphabetically
      await performFiltering(prefix: "", favoritesOnly: searchFavoritesOnly)
      return
    }
    print("searchTerm: \(searchTerm)")
    await filterCitiesData(with: searchTerm, favoritesOnly: searchFavoritesOnly)
  }
  
  @MainActor
  private func fetchCities() async {
    do {
      isInitialLoading = true
      let result = try await dependencies.getCitiesUseCase.execute(url: APIConstants.citiesURL)
      await processCities(result)
      
      // Now use the trie to find matching cities
      await performFiltering(prefix: searchTerm, favoritesOnly: searchFavoritesOnly)
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
    }
  }
  
  private func performFiltering(prefix: String, favoritesOnly: Bool) async {
    let matchingCities: [City]
    
    if prefix.isEmpty {
      // No search text, show all cities or just favorites, always in alphabetical order
      matchingCities = favoritesOnly ?
      cities.filter { favoriteCities.contains($0.id) } :
      cities
    } else {
      // Find matching indices using the trie
      let matchIndices = prefixTrie.findIndices(with: prefix.lowercased())
      
      // Map indices back to cities
      let unfilteredMatches = matchIndices.compactMap { index -> City? in
        guard index < cities.count else { return nil }
        return cities[index]
      }
      
      // Apply favorites filter if needed
      matchingCities = favoritesOnly ?
      unfilteredMatches.filter { favoriteCities.contains($0.id) } :
      unfilteredMatches
    }
    
    // Update on the main thread
    await MainActor.run {
      self.filteredCities = matchingCities
      viewContent = transformCitiesToCellItems(self.filteredCities)
      noMatchesFound = viewContent.isEmpty
    }
  }
  
  func filterCitiesData(with prefix: String, favoritesOnly: Bool) async {
    // Cancel any previous task to ensure UI responsiveness
    task?.cancel()
    
    task = Task {
      await performFiltering(prefix: prefix, favoritesOnly: favoritesOnly)
    }
  }
  
  func onSelectedCity(_ city: CityCellItem?) {
    // Implementation would go here
  }
  
  private func transformCitiesToCellItems(_ cities: [City]) -> [CityCellItem] {
    return cities.map { city in
      CityCellItem(
        id: city.id,
        title: "\(city.name), \(city.country)",
        subtitle: "Lat: \(city.coord.lat), Lon: \(city.coord.lon)",
        isFavorite: favoriteCities.contains(city.id),
        lat: city.coord.lat,
        lon: city.coord.lon
      )
    }
  }
}
