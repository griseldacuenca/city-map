//
//  Extensions.swift
//  CityMap
//
//  Created by Griselda Cuenca on 01/04/2025.
//

import SwiftUI

extension UIDeviceOrientation {
  var isPortrait: Bool {
    return self == .portrait || self == .portraitUpsideDown
  }
  
  var isLandscape: Bool {
    return self == .landscapeLeft || self == .landscapeRight
  }
}

extension View {
  func cellBackground(index: Int, isSelected: Bool = false) -> some View {
    self.modifier(CellBackgroundModifier(index: index, isSelected: isSelected))
  }
}
