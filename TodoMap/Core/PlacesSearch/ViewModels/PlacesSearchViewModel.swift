//
//  PlacesSearchViewModel.swift
//  TodoMap
//
//  Created by Suguru on 8/21/23.
//

import Foundation
import Combine

class PlaceSearchViewModel : ObservableObject {
    @Published var searchText: String = ""
    @Published var isLoading: Bool = false
    @Published var nearbySearchResults: [NearbySearchResult] = []
    @Published var predictions: [Prediction] = []
    @Published var region = LocationService.shared.mapRegion
    var searchRadius: Int = 10_000 // 10km
    var searchTextCancellable: Cancellable? = nil
    
    init() {
        addSubscriptions()
    }
    
    func addSubscriptions() {
        // listen to search text
        Task {
            for await value in $searchText
                .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
                .values {
                if !value.isEmpty {
                    try await self.getSearchResults(query: value)
                } else {
                    DispatchQueue.main.async {
                        self.predictions = []
                        self.nearbySearchResults = []
                    }
                }
            }
        }
        
        Task {
            for await value in LocationService.shared.$mapRegion.values {
                await MainActor.run(body: {
                    self.region = value
                })
            }
        }
    }
    
    func getSearchResults(query: String) async throws {
        do {
            DispatchQueue.main.async {
                self.isLoading = true
            }
            
            if let autocompleteRes = try await MapsService.shared.getAutoCompletePlaces(query: query, radius: searchRadius),
               let nearBySearchRes = try await MapsService.shared.getNearbySearchResults(query: query, radius: searchRadius) {
                DispatchQueue.main.async {
                    self.predictions = autocompleteRes.predictions ?? []
                    self.nearbySearchResults = nearBySearchRes.results ?? []
                }
            }
            
            DispatchQueue.main.async {
                self.isLoading = false
            }
        } catch {
            throw error
        }
    }
    
    func resetSearch() {
        self.predictions = []
        self.nearbySearchResults = []
        self.searchText = ""
    }
}
