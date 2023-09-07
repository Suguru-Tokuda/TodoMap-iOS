//
//  PlacesSearchListView.swift
//  TodoMap
//
//  Created by Suguru on 8/21/23.
//

import SwiftUI

struct PlaceSearchListView: View {
    var predictions: [Prediction]
    var nearbySearchResults: [NearbySearchResult]
    @EnvironmentObject private var vm: PlaceSearchViewModel
    
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
                            print(prediction)
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
                        UIApplication.shared.endEditing()
                         print(result)
                        } label: {
                            NearBySearchListRowView(result: result, region: $vm.region)
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
