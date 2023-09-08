//
//  TodoMapViewModel.swift
//  TodoMap
//
//  Created by Suguru Tokuda on 8/19/23.
//

import MapKit

class TodoMapViewModel: ObservableObject {
    @Published var mapRegion: MKCoordinateRegion?
    @Published var annotations: [MKAnnotation] = []
    
    init() {
        if let region = LocationService.shared.mapRegion {
            self.mapRegion = region
        }
        addSubscription()
    }
    
    func addSubscription() {
        Task {
            for await value in LocationService.shared.$mapRegion.values {
                await MainActor.run(body: {
                    if let value = value {
                        self.mapRegion = value
                    }
                })
            }
        }
    }
    
    func checkIfLocationServicesIsEnabled() {
        Task {
            await LocationService.shared.checkIfLocationServicesIsEnabled()
        }
    }
}
