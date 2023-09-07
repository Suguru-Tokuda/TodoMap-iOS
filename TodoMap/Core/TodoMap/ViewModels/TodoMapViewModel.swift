//
//  TodoMapViewModel.swift
//  TodoMap
//
//  Created by Suguru Tokuda on 8/19/23.
//

import MapKit

class TodoMapViewModel: ObservableObject {
    @Published var mapRegion: MKCoordinateRegion = LocationService.shared.mapRegion
    @Published var annotations: [MKAnnotation] = []
    
    init() {
        addSubscription()
    }
    
    func addSubscription() {
        Task {
            for await value in LocationService.shared.$mapRegion.values {
                await MainActor.run(body: {
                    self.mapRegion = value
                })
            }
        }
    }
    
    func checkIfLocationServicesIsEnabled() {
        Task { [weak self] in
            await LocationService.shared.checkIfLocationServicesIsEnabled()
        }
    }
}
