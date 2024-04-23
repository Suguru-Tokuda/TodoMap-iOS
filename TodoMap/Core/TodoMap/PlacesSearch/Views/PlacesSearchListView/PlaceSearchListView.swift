//
//  PlacesSearchListView.swift
//  TodoMap
//
//  Created by Suguru on 8/21/23.
//

import SwiftUI

struct PlaceSearchListView: View {
    @EnvironmentObject private var vm: PlaceSearchViewModel
    @EnvironmentObject var locationManager: LocationManager
    var predictions: [Prediction]
    var nearbySearchResults: [NearbySearchResult]
    var onPredictionSelected: ((Prediction) -> ())?
    var onNearbySearhcResultSelected: ((NearbySearchResult) -> ())?
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                autoCompleteList()
                nearbySearchList()
            }
        }
        .onAppear {
            vm.setLocationManager(locationManager: locationManager)
        }
        .scrollDismissesKeyboard(.interactively)
    }
}

extension PlaceSearchListView {
    @ViewBuilder
    func autoCompleteList() -> some View {
        if !predictions.isEmpty {
            HStack {
                Text(String.constants.autocomplete)
                    .font(.callout)
                    .fontWeight(.bold)
                    .foregroundColor(Color.theme.text)
                Spacer()
            }
            .padding(.horizontal, 5)

            ForEach(predictions, id: \.self.id) { prediction in
                Button {
                    onPredictionSelected?(prediction)
                    UIApplication.shared.endEditing()
                } label: {
                    AutoCompleteListRowView(prediction: prediction)
                }
            }
        }
    }
    
    @ViewBuilder
    func nearbySearchList() -> some View {
        if !nearbySearchResults.isEmpty {
            HStack {
                Text(String.constants.nearbySearch)
                    .font(.callout)
                    .fontWeight(.bold)
                    .foregroundColor(Color.theme.text)
                Spacer()
            }
            .padding(.horizontal, 5)

            ForEach(nearbySearchResults, id: \.self.id) { result in
                Button {
                    onNearbySearhcResultSelected?(result)
                    UIApplication.shared.endEditing()
                } label: {
                    NearBySearchListRowView(result: result, region: vm.region)
                }
            }
        }

    }
}

struct PlacesSearchListView_Previews: PreviewProvider {
    static var previews: some View {
        PlaceSearchListView(predictions: dev.placePredictions, nearbySearchResults: dev.nearbySearchResults)
            .environmentObject(PlaceSearchViewModel())
            .environmentObject(LocationManager())
            .preferredColorScheme(.dark)
        PlaceSearchListView(predictions: dev.placePredictions, nearbySearchResults: dev.nearbySearchResults)
            .environmentObject(PlaceSearchViewModel())
            .environmentObject(LocationManager())
    }
}
