//
//  ViewModifiers.swift
//  CityMap
//
//  Created by Griselda Cuenca on 02/04/2025.
//

import SwiftUI

struct CellBackgroundModifier: ViewModifier {
  let index: Int
  let isSelected: Bool
  
  func body(content: Content) -> some View {
    let baseColor = index % 2 == 0 ? Color.white : Color(.systemGray6)
    let selectedColor = Color.blue.opacity(0.1)
    
    return content
      .background(
        RoundedRectangle(cornerRadius: 8)
          .fill(isSelected ? selectedColor : baseColor)
      )
  }
}


