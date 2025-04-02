//
//  Untitle.swift
//  CityMap
//
//  Created by Griselda Cuenca on 02/04/2025.
//

import XCTest
@testable import CityMap

final class CityListViewModelTests: XCTestCase {
  
  var viewModel: CityListViewModel!
  var mockGetCitiesUseCase: MockGetCitiesUseCase!
  
  override func setUp() {
    super.setUp()
    mockGetCitiesUseCase = MockGetCitiesUseCase()
    viewModel = CityListViewModel(dependencies: .init(getCitiesUseCase: mockGetCitiesUseCase))
  }
  
  override func tearDown() {
    viewModel = nil
    mockGetCitiesUseCase = nil
    super.tearDown()
  }
  
  func test_fetchCities_success() async {
    // Given
    let mockCities = [City.mock]
    mockGetCitiesUseCase.result = .success(mockCities)
    
    // When
    await viewModel.handleOnAppear()
    
    // Then
    XCTAssertFalse(viewModel.isInitialLoading)
    XCTAssertEqual(viewModel.cities, mockCities)
  }
  
  func test_fetchCities_failure() async {
    // Given
    mockGetCitiesUseCase.result = .failure(APIError.invalidResponse)
    
    // When
    await viewModel.handleOnAppear()
    
    // Then
    XCTAssertFalse(viewModel.isInitialLoading)
    XCTAssertTrue(viewModel.cities.isEmpty)
  }
  
  func test_searchCities_found() async {
    // Given
    let mockCities = [City(id: 1, name: "Paris", country: "FR", coord: Coordinates(lon: 2.3522, lat: 48.8566))]
    mockGetCitiesUseCase.result = .success(mockCities)
    await viewModel.handleOnAppear()
    
    // When
    viewModel.searchTerm = "Paris"
    await viewModel.onSearch()
    
    // Then
    XCTAssertFalse(viewModel.noMatchesFound)
    XCTAssertEqual(viewModel.filteredCities.count, 1)
  }
  
  func test_searchCities_notFound() async {
    // Given
    let mockCities = [City(id: 1, name: "Paris", country: "FR", coord: Coordinates(lon: 2.3522, lat: 48.8566))]
    mockGetCitiesUseCase.result = .success(mockCities)
    await viewModel.handleOnAppear()
    
    // When
    viewModel.searchTerm = "London"
    
    let expectation = XCTestExpectation(description: "Search completes and updates noMatchesFound")
    
    // Observe changes to noMatchesFound
    let cancellable = viewModel.$noMatchesFound.sink { noMatches in
      if noMatches {
        expectation.fulfill()
      }
    }
    
    await viewModel.onSearch()
    
    // Then
    await fulfillment(of: [expectation], timeout: 2.0)
    
    XCTAssertTrue(viewModel.noMatchesFound)
    
    cancellable.cancel()
  }
  
  func test_toggleFavorite_addsCity() {
    // Given
    let city = City.mock
    viewModel.viewContent = [CityCellItem(id: city.id, title: city.name, subtitle: "", isFavorite: false, lat: 0, lon: 0)]
    
    // When
    viewModel.handleOnToggleFavorite(with: 0)
    
    // Then
    XCTAssertTrue(viewModel.favoriteCities.contains(city.id))
  }
  
  func test_toggleFavorite_removesCity() {
    // Given
    let city = City.mock
    viewModel.favoriteCities.insert(city.id)
    viewModel.viewContent = [CityCellItem(id: city.id, title: city.name, subtitle: "", isFavorite: true, lat: 0, lon: 0)]
    
    // When
    viewModel.handleOnToggleFavorite(with: 0)
    
    // Then
    XCTAssertFalse(viewModel.favoriteCities.contains(city.id))
  }
}

final class MockGetCitiesUseCase: GetCitiesUseCaseProtocol {
  var result: Result<[City], Error>?
  
  func execute(url: String) async throws -> [City] {
    if let result = result {
      switch result {
      case .success(let cities): return cities
      case .failure(let error): throw error
      }
    }
    return []
  }
}
