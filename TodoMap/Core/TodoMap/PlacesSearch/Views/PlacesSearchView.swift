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
    var onLocationSelect: ((LocationModel) -> Void)?
    var handleBackBtnTapped: (() -> ())?
    @State var textFieldFocused: Bool = false
    
    var body: some View {
        ZStack {
            getBackground()
            mapView()
            searchView()
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
    @ViewBuilder
    func getBackground() -> some View {
        if !(!textFieldFocused && vm.predictions.count == 0 && vm.nearbySearchResults.count == 0) {
            Color.theme.background
                .ignoresSafeArea()
        }
    }

    @ViewBuilder
    func mapView() -> some View {
        MapContentView(onLocationSelect: { location in
            onLocationSelect?(location)
        })
            .background(ignoresSafeAreaEdges: .bottom)
            .onTapGesture {
                UIApplication.shared.endEditing()
            }
            .opacity((!textFieldFocused && vm.predictions.count == 0 && vm.nearbySearchResults.count == 0) ? 1 : 0)
    }
    
    @ViewBuilder
    func searchBarView() -> some View {
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
            .padding(.top, 10)
    }
    
    @ViewBuilder
    func searchView() -> some View {
        VStack {
            searchBarView()
            if !vm.predictions.isEmpty || !vm.nearbySearchResults.isEmpty {
                PlaceSearchListView(
                    predictions: vm.predictions,
                    nearbySearchResults: vm.nearbySearchResults,
                    onPredictionSelected: { prediction in
                        Task {
                            if let location = await vm.getLocation(prediction: prediction) {
                                onLocationSelect?(location)
                            }
                        }
                    },
                    onNearbySearhcResultSelected: { nearbySearchResult in
                        if let location = vm.getLocation(nearbySearchResult: nearbySearchResult) {
                            onLocationSelect?(location)
                        }
                    }
                )
                .environmentObject(vm)
            }
            Spacer()
        }
        .padding(.horizontal, 10)

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
