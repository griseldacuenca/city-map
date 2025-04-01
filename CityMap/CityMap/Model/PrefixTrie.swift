//
//  PrefixTrie.swift
//  CityMap
//
//  Created by Griselda Cuenca on 31/03/2025.
//

import Foundation

class PrefixTrie {
  private let root = TrieNode()
  
  func insert(word: String, index: Int) {
    var current = root
    
    for char in word {
      if current.children[char] == nil {
        current.children[char] = TrieNode()
      }
      current = current.children[char]!
      current.indices.append(index)
    }
  }
  
  func findIndices(with prefix: String) -> [Int] {
    var current = root
    
    // Navigate to the node representing the prefix
    for char in prefix {
      if let child = current.children[char] {
        current = child
      } else {
        return [] // Prefix not found
      }
    }
    
    // Return all indices associated with this prefix
    return current.indices
  }
}
