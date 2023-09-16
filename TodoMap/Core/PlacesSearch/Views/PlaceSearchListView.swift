//
//  PlacesSearchListView.swift
//  TodoMap
//
//  Created by Suguru on 8/21/23.
//

import SwiftUI

struct PlaceSearchListView: View {
    @EnvironmentObject private var vm: PlaceSearchViewModel
    var predictions: [Prediction]
    var nearbySearchResults: [NearbySearchResult]
    var onPredictionSelected: ((_ prediction: Prediction) -> ())?
    var onNearBySearhcResultSelected: ((_ result: NearbySearchResult) -> ())?
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
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
                            onNearBySearhcResultSelected?(result)
                            UIApplication.shared.endEditing()
                        } label: {
                            NearBySearchListRowView(result: result, region: vm.region)
                        }
                    }
                }
            }
        }
        .scrollDismissesKeyboard(.interactively)
    }
}

struct PlacesSearchListView_Previews: PreviewProvider {
    static var previews: some View {
        PlaceSearchListView(predictions: dev.placePredictions, nearbySearchResults: dev.nearbySearchResults)
            .environmentObject(PlaceSearchViewModel())
            .preferredColorScheme(.dark)
        PlaceSearchListView(predictions: dev.placePredictions, nearbySearchResults: dev.nearbySearchResults)
            .environmentObject(PlaceSearchViewModel())
    }
}
