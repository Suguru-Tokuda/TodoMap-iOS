//
//  PlacesSearchView.swift
//  TodoMap
//
//  Created by Suguru on 8/25/23.
//

import SwiftUI

struct PlacesSearchView: View {
    @StateObject var vm = PlaceSearchViewModel()
    @EnvironmentObject var locationManager: LocationManager
    var handleBackBtnTapped: (() -> ())?
    @State var textFieldFocused: Bool = false
    
    var body: some View {
        ZStack {
            TodoMapView()
                .background(ignoresSafeAreaEdges: .bottom)
                .onTapGesture {
                    UIApplication.shared.endEditing()
                }
                .opacity((!textFieldFocused && vm.predictions.count == 0 && vm.nearbySearchResults.count == 0) ? 1 : 0)
            
            if !(!textFieldFocused && vm.predictions.count == 0 && vm.nearbySearchResults.count == 0) {
                Color.theme.background
                    .ignoresSafeArea()
            }
                
            VStack {
                PlacesSearchBarView(
                    text: $vm.searchText,
                    isLoading: $vm.isLoading,
                    handleCancelBtnTapped: {
                        vm.resetSearch()
                        resetSearch()
                    },
                    handleBackBtnTapped: {
                        resetSearch()
                        handleBackBtnTapped?()
                    }) { focused in
                        withAnimation(.easeIn) {
                            textFieldFocused = focused
                        }
                    }
                if !vm.predictions.isEmpty || !vm.nearbySearchResults.isEmpty {
                    PlaceSearchListView(
                        predictions: vm.predictions,
                        nearbySearchResults: vm.nearbySearchResults
                    )
                    .environmentObject(vm)
                }
                Spacer()
            }
            .padding(.horizontal, 10)
        }
        .onAppear {
            vm.setLocationManager(locationManager: locationManager)
            Task {
                await vm.checkLocationServiceEnabled()
            }
        }
    }
}
    
extension PlacesSearchView {
    private func resetSearch() {
        withAnimation(.easeIn) {
            textFieldFocused = false
        }
    }
}

struct PlacesSearchView_Previews: PreviewProvider {
    static var previews: some View {
        PlacesSearchView()
            .preferredColorScheme(.dark)
        PlacesSearchView()
    }
}
