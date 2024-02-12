//
//  GoogleMapsService.swift
//  TodoMap
//
//  Created by Suguru on 8/21/23.
//

import MapKit
import Combine

protocol MapServiceURL {
    func getNearBySearchResultsURLStr(query: String, coordinate: CLLocationCoordinate2D, radius: Int, type: GooglePlaceType?) -> String
    func getAutoCompletePlacesURLStr(query: String, coordinate: CLLocationCoordinate2D, radius: Int, type: GooglePlaceType?) -> String
}

extension MapServiceURL {
    func getNearBySearchResultsURLStr(query: String, coordinate: CLLocationCoordinate2D, radius: Int, type: GooglePlaceType? = nil) -> String {
        return "\(Constants.googleMapsBaseURL)\(GooglePlacesAPIEndpoints.nearBySearch.rawValue)/json?" +
               "keyword=\(query)" +
               "&location=\(coordinate.latitude)%\(coordinate.longitude)" +
               "&radius=\(radius)" +
               "\(type != nil ? "&type=\(String(describing: type!.rawValue))" : "")" +
               "&key=\(Keys.googleAPIKey)"
            
    }
    
    func getAutoCompletePlacesURLStr(query: String, coordinate: CLLocationCoordinate2D, radius: Int, type: GooglePlaceType?) -> String {
        return "\(Constants.googleMapsBaseURL)\(GooglePlacesAPIEndpoints.autoComplete.rawValue)/json?" +
               "input=\(query)" +
               "&location=\(coordinate.latitude)%\(coordinate.longitude)" +
               "&radius=\(radius)" +
               "\(type != nil ? "&type=\(String(describing: type!.rawValue))" : "")" +
               "&key=\(Keys.googleAPIKey)"
    }
}

class MapsService: MapServiceURL {
    var region: MKCoordinateRegion?
    let networkManager: Networking
    var locationManager: LocationManager?
    var cancellables = Set<AnyCancellable>()
    var locationCancellable: AnyCancellable?
    
    init(networkManager: Networking = NetworkManager()) {
        self.networkManager = networkManager
    }

    func getNearbySearchResults(query: String, radius: Int, type: GooglePlaceType? = nil) async throws -> GoogleNearbySearchModel? {
        do {
            if let coordinate = locationManager?.center?.center {
                let urlStr = getNearBySearchResultsURLStr(query: query, coordinate: coordinate, radius: radius, type: type)

                guard let url = URL(string: urlStr) else { return nil }
                var retVal = try await networkManager.get(url: url, type: GoogleNearbySearchModel.self)
                
                if var results = retVal.results {
                    for i in 0..<results.count {
                        let result = results[i]
                        if let geometry = result.geometry,
                           let location = geometry.location {
                            results[i].distanceInMeter = region?.getDistance(latitude: location.lat, longitude: location.lng)
                        }
                    }
                    
                    retVal.results = results.sorted(by: { $0.distanceInMeter! < $1.distanceInMeter! })
                }
                
                return retVal
            } else {
                return nil
            }
        } catch {
            throw error
        }
    }
    
    func getAutoCompletePlaces(query: String, radius: Int, type: GooglePlaceType? = nil) async throws -> GoogleAutoCompleteModel? {
        do {
            if let region = locationManager?.center {
                let coordinate = region.center
                let urlStr = getAutoCompletePlacesURLStr(query: query, 
                                                         coordinate: coordinate,
                                                         radius: radius,
                                                         type: type)
                
                guard let url = URL(string: urlStr) else { return nil }
                
                let retVal = try await networkManager.get(url: url, type: GoogleAutoCompleteModel.self)
                return retVal
            } else {
                return nil
            }
        } catch {
            throw error
        }
    }
    
    func getLocation(latitude: Double, longitude: Double) async throws -> ReverseGeocodeModel? {
        do {
            let urlStr = "\(Constants.googleGeocodeBaseURL)json?latlng=\(latitude),\(longitude)&key=\(Keys.googleAPIKey)"
            
            guard let url = URL(string: urlStr) else { return nil }
            
            let retVal = try await networkManager.get(url: url, type: ReverseGeocodeModel.self)
            
            return retVal
        } catch {
            throw error
        }
    }
    
    func setLocationManager(locationManager: LocationManager) {
        self.locationManager = locationManager
        self.region = locationManager.center
    }
}
