//
//  GetCitiesUseCase.swift
//  CityMap
//
//  Created by Griselda Cuenca on 28/03/2025.
//

import Foundation

protocol GetCitiesUseCaseProtocol {
  func execute(url: String) async throws -> [City]
}

struct GetCitiesUseCase: GetCitiesUseCaseProtocol {
  
  let api = APIRequestBuilder()

  func execute(url: String) async throws -> [City] {
    return try await api.performRequest(url: url, method: .get, decodingType: [City].self)
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
