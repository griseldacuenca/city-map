//
//  APICall.swift
//  CityMap
//
//  Created by Griselda Cuenca on 28/03/2025.
//

import Foundation

enum APIError: Error {
  case invalidURL
  case invalidURLFromComponents
  case invalidResponse
  case unableToParseResponse
}

enum HttpMethod: String {
  case get = "GET"
  case post = "POST"
  case put = "PUT"
  case delete = "DELETE"
}

struct APIRequestBuilder {
  
  private func makeRequest(url: String,
                           method: String,
                           queryItems: [URLQueryItem]? = nil,
                           body: Data? = nil,
                           headers: [String: String]? = nil
  ) async throws -> Data {
    guard let endpoint = URL(string: "https://\(url)") else {
      debugPrint("Failed to create endpoint URL: \(url)")
      throw APIError.invalidURL
    }
    
    var components = URLComponents(url: endpoint, resolvingAgainstBaseURL: false)
    components?.queryItems = queryItems
    
    guard let finalURL = components?.url else {
      debugPrint("Failed to read endpoint from URL components: \(url)")
      throw APIError.invalidURLFromComponents
    }
    
    let request = NSMutableURLRequest(url: finalURL)
    request.httpMethod = method
    request.httpBody = body
    
    let (data, response) = try await URLSession.shared.data(for: request as URLRequest)
    
    guard let httpResponse = response as? HTTPURLResponse,
          (200..<300).contains(httpResponse.statusCode) else {
      debugPrint("Failed to make request to \(finalURL.absoluteString). Response: \(String(describing: response))")
      throw APIError.invalidResponse
    }
    
    return data
  }
  
  func performRequest<T: Decodable>(
    url: String,
    method: HttpMethod,
    queryItems: [URLQueryItem]? = nil,
    body: Data? = nil,
    headers: [String: String]? = nil,
    decodingType: T.Type,
    keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy? = nil,
    dateDecodingStrategy: JSONDecoder.DateDecodingStrategy? = nil,
    searchPath: Bool = false,
    useJSONHeader: Bool = false
  ) async throws -> T {
    let data = try await makeRequest(url: url, method: method.rawValue, queryItems: queryItems, body: body, headers: headers)
    
    do {
      let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
      let prettyPrintedData = try JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)
      if let prettyPrintedString = String(data: prettyPrintedData, encoding: .utf8) {
        debugPrint("Response: \(prettyPrintedString)")
      }
      
      let decoder = JSONDecoder()
      if let decodingStrategy = keyDecodingStrategy {
        decoder.keyDecodingStrategy = decodingStrategy
      }
      if let dateDecodingStrategy = dateDecodingStrategy {
        decoder.dateDecodingStrategy = dateDecodingStrategy
      }
      let results = try decoder.decode(T.self, from: data)
      return results
    } catch {
      debugPrint("Error: \(error)")
      throw APIError.unableToParseResponse
    }
  }
}
