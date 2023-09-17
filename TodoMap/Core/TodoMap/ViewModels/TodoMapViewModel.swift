//
//  TodoMapViewModel.swift
//  TodoMap
//
//  Created by Suguru Tokuda on 8/19/23.
//

import MapKit
import Combine

class TodoMapViewModel: ObservableObject {
    @Published var mapRegion: MKCoordinateRegion?
    @Published var annotations: [MKPointAnnotation] = []
    @Published var locationSelectionSheeetPresented: Bool = false
    @Published var location: ReverseGeocodeModel?
    var cancellables: Set<AnyCancellable> = []
    
    init() {
        if let region = LocationService.shared.center {
            self.mapRegion = region
        }
        addSubscription()
    }
    
    deinit {
        cancellables.forEach { cancellable in cancellable.cancel() }
    }
    
    private func addSubscription() {
        LocationService.shared.$center
            .receive(on: DispatchQueue.main)
            .sink { value in
                Task {
                    await MainActor.run(body: {
                        if let value = value {
                            self.mapRegion = value
                        }
                    })
                }
            }
            .store(in: &cancellables)
        $locationSelectionSheeetPresented
            .receive(on: DispatchQueue.main)
            .sink { value in
                print(value)
                if !value { self.annotations = [] }
                print(self.annotations.count)
            }
            .store(in: &cancellables)
    }
    
    func checkIfLocationServicesIsEnabled() {
        Task {
            await LocationService.shared.checkIfLocationServicesIsEnabled()
        }
    }
    
    func getLocationDetails(coordinate: CLLocationCoordinate2D) async throws {
        do {
            if let location = try await MapsService.shared.getLocation(latitude: coordinate.latitude, longitude: coordinate.longitude) {
                DispatchQueue.main.async {
                    self.locationSelectionSheeetPresented = true
                    self.location = location
                }
            }
        } catch {
            throw error
        }
    }
    
    func addAnnotation(annotation: MKPointAnnotation, reset: Bool = false) {
        if reset { self.annotations = [annotation] }
        else { self.annotations.append(annotation) }
        
        print(self.annotations.count)
    }
}
