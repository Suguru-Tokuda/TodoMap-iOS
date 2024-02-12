//
//  LocationService.swift
//  TodoMap
//
//  Created by Suguru on 9/2/23.
//

import MapKit
import Combine

enum MapDetails {
//    static let startingLocation = CLLocationCoordinate2D(latitude: 37.33233141, longitude: -122.0312186)
    static let defaultSpan = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
}

class LocationManager: NSObject, CLLocationManagerDelegate, ObservableObject {
    var locationManager: CLLocationManager?
    @Published var center: MKCoordinateRegion?
    @Published var currentLocation: MKCoordinateRegion?
    @Published var locationError: LocationError?
    
    override init() {
        super.init()
        Task {
            await self.checkIfLocationServicesIsEnabled()
        }        
    }
        
    func checkIfLocationServicesIsEnabled() async {
        if CLLocationManager.locationServicesEnabled() {
            self.locationManager = CLLocationManager()
            self.locationManager?.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager?.distanceFilter = kCLDistanceFilterNone
            self.locationManager?.requestWhenInUseAuthorization()
            self.locationManager?.startUpdatingLocation()
            self.locationManager?.delegate = self
            self.updateCurrentLocation()
        } else {
            self.locationError = .unauthorized
//            print("Show an alert letting them know this is off and to go turn it on")
        }
    }
    
    public func updateCurrentLocation() {
        guard let locationManager else { return }
        if let location = locationManager.location {
            DispatchQueue.main.async {
                self.currentLocation = MKCoordinateRegion(center: location.coordinate, span: MapDetails.defaultSpan)
                if self.center == nil {
                    if let currentLocation = self.currentLocation {
                        self.center = currentLocation
                    }
                }
            }
        }
    }
    
    public func checkLocationAuthorization() {
        guard let locationManager else { return }
        
        switch locationManager.authorizationStatus {
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
            case .restricted:
                self.locationError = .restricted
                print("Your location is restricted likely due to parental controls.")
            case .denied:
                self.locationError = .denied
                print("You have denied this app location permission. Go into settings to change it.")
            case .authorizedAlways, .authorizedWhenInUse:
            self.locationError = nil
            updateCurrentLocation()
            @unknown default:
                break
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if center == nil {
            center = MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: (manager.location?.coordinate.latitude)!,
                                               longitude: (manager.location?.coordinate.longitude)!),
                span: MapDetails.defaultSpan)
        } else {
            center!.center.latitude = (manager.location?.coordinate.latitude)!
            center!.center.longitude = (manager.location?.coordinate.longitude)!
        }
    }
}
