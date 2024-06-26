//
//  PlacesSearchViewModel.swift
//  TodoMap
//
//  Created by Suguru on 8/21/23.
//

import Foundation
import Combine
import MapKit

class PlaceSearchViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var isLoading: Bool = false
    @Published var nearbySearchResults: [NearbySearchResult] = []
    @Published var predictions: [Prediction] = []
    @Published var region: MKCoordinateRegion?
    @Published var errorOccured: Bool = false
    
    var networkError: NetworkError?
    var mapsService: MapsService
    var locationManager: LocationManager
    var searchRadius: Int = 10_000 // 10km
    var cancellables: Set<AnyCancellable> = []
    
    init(mapsService: MapsService = MapsService(), locationManager: LocationManager = LocationManager()) {
        self.mapsService = mapsService
        self.locationManager = locationManager
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
        self.locationManager.centerSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                guard let self = self else { return }
                if let value {
                    Task {
                        await MainActor.run(body: {
                            self.region = value
                        })
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    func getSearchResults(query: String) async throws {
        do {
            DispatchQueue.main.async {
                self.isLoading = true
            }
            
             if let autocompleteRes = try await mapsService.getAutoCompletePlaces(query: query, radius: searchRadius),
               let nearBySearchRes = try await mapsService.getNearbySearchResults(query: query, radius: searchRadius) {
                DispatchQueue.main.async {
                    self.predictions = autocompleteRes.predictions ?? []
                    self.nearbySearchResults = nearBySearchRes.results ?? []
                }
            }
            
            DispatchQueue.main.async {
                self.isLoading = false
            }
        } catch {
            DispatchQueue.main.async {
                if let error = error as? NetworkError? {
                    self.networkError = error
                    self.errorOccured = true
                }
            }
        }
    }
    
    func resetSearch() {
        self.predictions = []
        self.nearbySearchResults = []
        self.searchText = ""
    }
    
    func checkLocationServiceEnabled() async {
        await self.locationManager.checkIfLocationServicesIsEnabled()
    }
    
    func setLocationManager(locationManager: LocationManager) {
        self.locationManager = locationManager
        self.mapsService.setLocationManager(locationManager: locationManager)
    }
    
    func getLocation(prediction: Prediction) async -> LocationModel? {
        do {
            let placeDetails = try await mapsService.getLocationDetails(placeId: prediction.placeId)
            if let placeDetails {
                let retVal: LocationModel = .init(name: placeDetails.formattedAddress,
                                                  coordinates: CLLocationCoordinate2D(latitude: placeDetails.location.latitude,
                                                                                      longitude: placeDetails.location.longitude))
                return retVal
            } else {
                return nil
            }
        } catch {
            DispatchQueue.main.async {
                if let error = error as? NetworkError? {
                    self.networkError = error
                    self.errorOccured = true
                }
            }
        }
        
        return nil
    }
    
    func getLocation(nearbySearchResult: NearbySearchResult) -> LocationModel? {
        if let name = nearbySearchResult.name,
           let location = nearbySearchResult.geometry?.location {
            return LocationModel(name: name, coordinates: CLLocationCoordinate2D(latitude: location.lat, longitude: location.lng))
        } else {
            return nil
        }
    }
}
