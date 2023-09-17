//
//  PlacesSearchViewModel.swift
//  TodoMap
//
//  Created by Suguru on 8/21/23.
//

import Foundation
import Combine
import MapKit

class PlaceSearchViewModel : ObservableObject {
    @Published var searchText: String = ""
    @Published var isLoading: Bool = false
    @Published var nearbySearchResults: [NearbySearchResult] = []
    @Published var predictions: [Prediction] = []
    @Published var region: MKCoordinateRegion? = LocationService.shared.center
    var searchRadius: Int = 10_000 // 10km
    var cancellables: Set<AnyCancellable> = []
    
    init() {
        addSubscriptions()
    }
    
    deinit {
        cancellables.forEach { cancellable in cancellable.cancel() }
    }
    
    func addSubscriptions() {
        // listen to search text
        $searchText
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .receive(on: DispatchQueue.main)
            .sink { value in
                Task {
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
            .store(in: &cancellables)
        
        // listen to location center change
        LocationService.shared.$center
            .receive(on: DispatchQueue.main)
            .sink { value in
                Task {
                    await MainActor.run(body: {
                        if let value = value {
                            self.region = value
                        }
                    })
                }
            }
            .store(in: &cancellables)
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
