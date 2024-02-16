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
    @Published var location: ReverseGeocodeModel?
    @Published var networkError: NetworkError?

    var locationManager: LocationManager?
    var mapsService: MapsService
    var cancellables: Set<AnyCancellable> = []
    var showSelectionSheet: ((ReverseGeocodeModel) -> ())?
    
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
            .sink { [weak self] value in
                guard let self = self else { return }
                if value != nil {
                    DispatchQueue.main.async {
                        self.mapRegion = value
                    }
                }
            }
            .store(in: &cancellables)
    }
        
    func getLocationDetails(coordinate: CLLocationCoordinate2D) async {
        do {
            if let location = try await mapsService.getLocation(latitude: coordinate.latitude, longitude: coordinate.longitude) {
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    showSelectionSheet?(location)
//                    self.locationSelectionSheeetPresented = true
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
        DispatchQueue.main.async {
            if reset { self.annotations = [] }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.annotations.append(annotation)
            }
        }
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
