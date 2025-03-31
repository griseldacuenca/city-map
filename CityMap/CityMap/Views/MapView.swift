//
//  MapView.swift
//  CityMap
//
//  Created by Griselda Cuenca on 30/03/2025.
//

import SwiftUI
import MapKit

struct CityMapView: View {
  
  var body: some View {
    EmptyView()
  }

//  @State private var position: MapCameraPosition = .automatic
//  
//  let cities: [City] = [
//    .init(country: "UA", name: "Hurzuf", id: 123, coord: .init(lon: 34.283333, lat: 44.549999)),
//    .init(country: "AU", name: "Hurzuf", id: 124, coord: .init(lon: 151.2093, lat: -33.8688))
//  ]
//  
//  var body: some View {
//    Map(position: $position) {
//      ForEach(cities, id: \.id) { city in
//        Annotation(city.name, coordinate: CLLocationCoordinate2D(latitude: city.coord.lat, longitude: city.coord.lon)) {
//          Image(systemName: "mappin.circle.fill")
//            .foregroundColor(.red)
//            .font(.title)
//        }
//      }
//    }
//    .onAppear {
//      if let firstCity = cities.first {
//        let cityCoordinates = CLLocationCoordinate2D(latitude: firstCity.coord.lat, longitude: firstCity.coord.lon)
//        position = .region(MKCoordinateRegion(center: cityCoordinates, span: MKCoordinateSpan(latitudeDelta: 5, longitudeDelta: 5)))
//      }
//    }
//  }
}

#Preview {
  CityMapView()
}


