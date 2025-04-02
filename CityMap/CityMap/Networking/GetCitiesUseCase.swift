//
//  GetCitiesUseCase.swift
//  CityMap
//
//  Created by Griselda Cuenca on 28/03/2025.
//

import Foundation
import Compression

protocol GetCitiesUseCaseProtocol {
  func execute(url: String) async throws -> [City]
}

struct GetCitiesUseCase: GetCitiesUseCaseProtocol {
  
  let api = APIRequestBuilder()
  
  /// File path for compressed cities JSON
  private var compressedFilePath: URL {
    FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
      .first!.appendingPathComponent("cities.json.gz")
  }
  
  
  
  func execute(url: String) async throws -> [City] {
    let lastUpdate = UserDefaults.standard.double(forKey: FileManagerConstants.lastUpdateKey)
    let currentTime = Date().timeIntervalSince1970
    
    // Check if the cache is still fresh
    // Compare the expiration time before refetching
    if FileManager.default.fileExists(atPath: compressedFilePath.path),
       currentTime - lastUpdate < FileManagerConstants.updateInterval {
      print("Using cached data (Updated: \(Date(timeIntervalSince1970: lastUpdate)))")
      return try await loadCompressedJSON()
    }
    
    // If outdated or it does not exist, fetch fresh data from API
    print("Fetching fresh data from API...")
    let cities = try await api.performRequest(url: url, method: .get, decodingType: [City].self)
    
    // Save compressed JSON & update timestamp
    try saveCompressedJSON(cities)
    UserDefaults.standard.set(currentTime, forKey: FileManagerConstants.lastUpdateKey)
    
    return cities
  }
  
  /// Compress and save the JSON data to disk
  private func saveCompressedJSON(_ cities: [City]) throws {
    let jsonData = try JSONEncoder().encode(cities)
    let compressedData = try (jsonData as NSData).compressed(using: .lzfse) // LZFSE is faster than Gzip
    try compressedData.write(to: compressedFilePath)
    print("Compressed JSON saved: \(compressedFilePath.path)")
  }
  
  /// Load and decompress JSON from disk
  private func loadCompressedJSON() async throws -> [City] {
    let compressedData = try Data(contentsOf: compressedFilePath)
    let decompressedData = try (compressedData as NSData).decompressed(using: .lzfse)
    return try JSONDecoder().decode([City].self, from: decompressedData as Data)
  }
}


struct MockGetCitiesUseCase: GetCitiesUseCaseProtocol {
  
  var mockExecute: (String) async throws -> [City] = { _ in
    [.mock]
  }
  
  func execute(url: String) async throws -> [City]  {
    try await mockExecute(url)
  }
}
