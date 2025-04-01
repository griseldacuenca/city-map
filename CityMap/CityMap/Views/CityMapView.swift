//
//  MapView.swift
//  CityMap
//
//  Created by Griselda Cuenca on 30/03/2025.
//

import SwiftUI
import MapKit

struct CityMapView: View {

  let city: CityCellItem
  @State private var position: MapCameraPosition = .automatic
  
  var body: some View {
      VStack {
        Map(position: $position) {
          Annotation(city.title, coordinate: CLLocationCoordinate2D(latitude: city.lat, longitude: city.lon)) {
            Image(systemName: "mappin.circle.fill")
              .foregroundColor(.red)
              .font(.title)
          }
        }
        .onAppear {
          let cityCoordinates = CLLocationCoordinate2D(latitude: city.lat, longitude: city.lon)
          position = .region(MKCoordinateRegion(center: cityCoordinates, span: MKCoordinateSpan(latitudeDelta: 5, longitudeDelta: 5)))
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
          ToolbarItem(placement: .principal) {
            Text(city.title).foregroundColor(Color.black).font(.headline)
          }
        }
      }
  }
}

#Preview {
  CityMapView(city: .init(id: 123,
                          title: "Denver, US",
                          subtitle: "Long: 24.28. Lat: 44.54",
                          isFavorite: false,
                          lat: 44.54,
                          lon: 24.28))
}


