//
//  LocationService.swift
//  TodoMap
//
//  Created by Suguru on 9/2/23.
//

import MapKit

enum MapDetails {
    static let startingLocation = CLLocationCoordinate2D(latitude: 37.33233141, longitude: -122.0312186)
    static let defaultSpan = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
}

class LocationService: NSObject, CLLocationManagerDelegate {
    static let shared = LocationService()
    var locationManager: CLLocationManager?
    @Published var mapRegion: MKCoordinateRegion?
    
    func checkIfLocationServicesIsEnabled() async {
        if CLLocationManager.locationServicesEnabled() {
            self.locationManager = CLLocationManager()
            self.locationManager!.delegate = self
            self.updateCurrentLocation()
        } else {
            print("Show an alert letting them know this is off and to go turn it on")
        }
    }
    
    public func updateCurrentLocation() {
        guard let locationManager = locationManager else { return }
        if let location = locationManager.location {
            mapRegion = MKCoordinateRegion(center: location.coordinate, span: MapDetails.defaultSpan)
        }
    }
    
    public func checkLocationAuthorization() {
        guard let locationManager = locationManager else { return }
        
        switch locationManager.authorizationStatus {
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
            case .restricted:
                print("Your location is restricted likely due to parental controls.")
            case .denied:
                print("You have denied this app location permission. Go into settings to change it.")
            case .authorizedAlways, .authorizedWhenInUse:
            updateCurrentLocation()
            @unknown default:
                break
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if mapRegion == nil {
            mapRegion = MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: (manager.location?.coordinate.latitude)!,
                                               longitude: (manager.location?.coordinate.longitude)!),
                span: MapDetails.defaultSpan)
        } else {
            mapRegion!.center.latitude = (manager.location?.coordinate.latitude)!
            mapRegion!.center.longitude = (manager.location?.coordinate.longitude)!
        }
    }
}
