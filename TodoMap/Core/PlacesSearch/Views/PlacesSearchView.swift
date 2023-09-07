//
//  PlacesSearchView.swift
//  TodoMap
//
//  Created by Suguru on 8/25/23.
//

import SwiftUI

struct PlacesSearchView: View {
    @StateObject var vm = PlaceSearchViewModel()
    
    var body: some View {
        ZStack {
            Color.theme.background
                .ignoresSafeArea()
            VStack {
                PlacesSearchBarView(text: $vm.searchText, isLoading: $vm.isLoading) {
                    vm.resetSearch()
                }
                if !vm.predictions.isEmpty || !vm.nearbySearchResults.isEmpty {
                    PlaceSearchListView(
                        predictions: vm.predictions,
                        nearbySearchResults: vm.nearbySearchResults
                    )
                    .environmentObject(vm)
                    Spacer()
                } else {
                    Spacer()
                }
            }
            .padding(.horizontal, 10)
        }
        .onAppear {
            Task {
                await LocationService.shared.checkIfLocationServicesIsEnabled()
            }
        }
    }
}
    
    extension PlacesSearchView {
        
    }

struct PlacesSearchView_Previews: PreviewProvider {
    static var previews: some View {
        PlacesSearchView()
            .preferredColorScheme(.dark)
        PlacesSearchView()
    }
}
