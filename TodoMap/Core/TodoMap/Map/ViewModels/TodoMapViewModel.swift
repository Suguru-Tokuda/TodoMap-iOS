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
    @Published var networkError: NetworkError?

    var locationManager: LocationManager?
    var mapsService: MapsService
    var cancellables: Set<AnyCancellable> = []
    
    init(mapsService: MapsService = MapsService()) {
        self.mapsService = mapsService
        addSubscription()
    }
    
    deinit {
        cancellables.forEach { cancellable in cancellable.cancel() }
    }
    
    private func addSubscription() {
        cancellables.removeAll()
        
        locationManager?.$center
            .receive(on: DispatchQueue.main)
            .sink { value in
                if value != nil {
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else { return }
                        self.mapRegion = value
                    }
                }
            }
            .store(in: &cancellables)

        $locationSelectionSheeetPresented
            .receive(on: DispatchQueue.main)
            .sink { value in
                if !value { self.annotations = [] }
            }
            .store(in: &cancellables)
    }
        
    func getLocationDetails(coordinate: CLLocationCoordinate2D) async {
        do {
            if let location = try await mapsService.getLocation(latitude: coordinate.latitude, longitude: coordinate.longitude) {
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.locationSelectionSheeetPresented = true
                    self.location = location
                }
            }
        } catch {
            if let error = error as? NetworkError {
                self.networkError = error
            }
        }
    }
    
    func addAnnotation(annotation: MKPointAnnotation, reset: Bool = false) {
        if reset { self.annotations = [annotation] }
        else { self.annotations.append(annotation) }
    }
    
    func handleNewCoordinate(coordinate: CLLocationCoordinate2D) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        
        if let location = location,
           let result = location.results.first {
            annotation.title = result.formattedAddress
            annotation.accessibilityValue = result.placeId
        }
        
        locationManager?.center = MKCoordinateRegion(center: coordinate, span: MapDetails.defaultSpan)
        addAnnotation(annotation: annotation, reset: true)
    }
    
    func checkLocationServiceEnabled() async {
        await self.locationManager?.checkIfLocationServicesIsEnabled()
    }
    
    func setLocationManager(locationManager: LocationManager) {
        self.locationManager = locationManager
        self.locationManager?.checkLocationAuthorization()
        self.locationManager?.updateCurrentLocation()
        self.addSubscription()

        Task(priority: .background) {
            await self.locationManager?.checkIfLocationServicesIsEnabled()
        }
    }
}