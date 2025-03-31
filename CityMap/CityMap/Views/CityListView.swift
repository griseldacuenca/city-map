//
//  ContentView.swift
//  CityMap
//
//  Created by Griselda Cuenca on 28/03/2025.
//

import SwiftUI

struct CityListView: View {
  @StateObject var vm = CityListViewModel(dependencies: .init(getCitiesUseCase: GetCitiesUseCase()))
  
  var body: some View {
      VStack {
        CitySearchBarView(isLoading: vm.isLoading,
                          searchTerm: $vm.searchTerm,
                          previousSelection: vm.previousSelection,
                          noMatchesFound: $vm.noMatchesFound,
                          onSearch: vm.onSearch,
                          onSelectedItem: vm.onSelectedCity)
        
        ScrollView {
          CityResultsView(noMatchesFound: vm.noMatchesFound,
                          results: vm.viewContent,
                          onSelectedItem: $vm.onSelectedItem)
        }
        
        Spacer()
      }
      .padding(.horizontal, 10)
  }
}

#Preview {
  CityListView()
}
