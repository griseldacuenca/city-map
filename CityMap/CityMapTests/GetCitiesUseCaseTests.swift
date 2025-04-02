//
//  CityMapTests.swift
//  CityMapTests
//
//  Created by Griselda Cuenca on 28/03/2025.
//

import XCTest
@testable import CityMap

final class GetCitiesUseCaseTests: XCTestCase {
  
  var useCase: GetCitiesUseCase!
  var mockAPI: MockAPIRequestBuilder!
  let testCities = [City.mock]
  
  override func setUp() {
    super.setUp()
    mockAPI = MockAPIRequestBuilder()
    useCase = GetCitiesUseCase(api: mockAPI)
    
    // Ensure a clean state before each test
    try? FileManager.default.removeItem(at: useCase.compressedFilePath)
    UserDefaults.standard.removeObject(forKey: FileManagerConstants.lastUpdateKey)
  }
  
  override func tearDown() {
    // Cleanup after each test
    try? FileManager.default.removeItem(at: useCase.compressedFilePath)
    UserDefaults.standard.removeObject(forKey: FileManagerConstants.lastUpdateKey)
    super.tearDown()
  }
  
  func testExecute_fetchesFreshData_whenNoCacheExists() async throws {
    // Given: No cached data, API returns testCities
    mockAPI.mockResponse = testCities
    
    // When: Calling execute()
    let result = try await useCase.execute(url: "https://fakeurl.com")
    
    // Then: API should be called, and result should match mock response
    XCTAssertEqual(result, testCities)
    XCTAssertTrue(mockAPI.didCallPerformRequest, "API should have been called")
  }
  
  func testExecute_usesCache_whenCacheIsFresh() async throws {
    // Given: Cache exists and is fresh
    try useCase.saveCompressedJSON(testCities)
    let recentTimestamp = Date().timeIntervalSince1970 - (FileManagerConstants.updateInterval / 2)
    UserDefaults.standard.set(recentTimestamp, forKey: FileManagerConstants.lastUpdateKey)
    
    // When: Calling execute()
    let result = try await useCase.execute(url: "https://fakeurl.com")
    
    // Then: API should NOT be called, and data should be from cache
    XCTAssertEqual(result, testCities)
    XCTAssertFalse(mockAPI.didCallPerformRequest, "API should NOT be called when cache is valid")
  }
  
  func testExecute_fetchesFreshData_whenCacheIsOutdated() async throws {
    // Given: Cache exists but is outdated
    try useCase.saveCompressedJSON(testCities)
    let oldTimestamp = Date().timeIntervalSince1970 - (FileManagerConstants.updateInterval * 2)
    UserDefaults.standard.set(oldTimestamp, forKey: FileManagerConstants.lastUpdateKey)
    
    // API should return new data
    let newCities = [City(id: 2, name: "New City", country: "XX", coord: Coordinates(lon: 10.0, lat: 20.0))]
    mockAPI.mockResponse = newCities
    
    // When: Calling execute()
    let result = try await useCase.execute(url: "https://fakeurl.com")
    
    // Then: API should be called, and result should match the new response
    XCTAssertEqual(result, newCities)
    XCTAssertTrue(mockAPI.didCallPerformRequest, "API should be called when cache is outdated")
  }
  
  func testSaveAndLoadCompressedJSON() async throws {
    // Given: Test data to save
    try useCase.saveCompressedJSON(testCities)
    
    // When: Loading the saved data
    let loadedCities = try await useCase.loadCompressedJSON()
    
    // Then: The loaded data should match the original
    XCTAssertEqual(loadedCities, testCities, "Decompressed data should match original data")
  }
}

// MARK: - Mock APIRequestBuilder

final class MockAPIRequestBuilder: APIRequestProtocol {
  var mockResponse: [City] = []
  var didCallPerformRequest = false
  
  func performRequest<T>(url: String, method: CityMap.HttpMethod, queryItems: [URLQueryItem]?, body: Data?, headers: [String : String]?, decodingType: T.Type, keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy?, dateDecodingStrategy: JSONDecoder.DateDecodingStrategy?) async throws -> T where T : Decodable {
    guard let response = mockResponse as? T else {
      throw NSError(domain: "MockError", code: -1, userInfo: nil)
    }
    didCallPerformRequest = true
    return response
  }
}

