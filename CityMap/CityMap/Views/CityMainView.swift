//
//  CityMainView.swift
//  CityMap
//
//  Created by Griselda Cuenca on 28/03/2025.
//

import SwiftUI

struct CityMainView: View {
  
  @StateObject var vm = CityListViewModel(dependencies: .init(getCitiesUseCase: GetCitiesUseCase()))
  @State private var selectedCity: CityCellItem?
  @State private var orientation = UIDevice.current.orientation
  
  var body: some View {
    GeometryReader { geometry in
      if orientation.isLandscape {
        // Landscape layout - side by side
        HStack(spacing: 0) {
          CityListView(vm: vm, selectedCity: $selectedCity, orientation: orientation)
            .frame(width: geometry.size.width * 0.4)
          
          // Map on the right
          if let selectedCity = selectedCity {
            CityMapView(city: selectedCity)
          } else {
            // Placeholder when no city is selected
            VStack {
              Spacer()
              Text("Select a city to view on the map")
                .font(.title2)
                .foregroundColor(.secondary)
              Spacer()
            }
            .frame(maxWidth: .infinity)
            .background(Color(.systemGray6))
          }
        }
      } else {
        // Portrait layout - navigation stack
        NavigationStack {
          CityListView(vm: vm, selectedCity: $selectedCity, orientation: orientation)
            .navigationDestination(for: CityCellItem.self) { city in
              CityMapView(city: city)
            }
        }
      }
    }
    .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
      self.orientation = UIDevice.current.orientation
    }
  }
}

#Preview {
  CityMainView(vm: CityListViewModel(dependencies: .init(getCitiesUseCase: MockGetCitiesUseCase())))
}
