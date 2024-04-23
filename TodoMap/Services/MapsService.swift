//
//  GoogleMapsService.swift
//  TodoMap
//
//  Created by Suguru on 8/21/23.
//

import MapKit
import Combine

protocol MapServiceURL {
    func getNearBySearchResultsURLStr(query: String, coordinate: CLLocationCoordinate2D, radius: Int, apiKey: String, type: GooglePlaceType?) -> String
    func getAutoCompletePlacesURLStr(query: String, coordinate: CLLocationCoordinate2D, radius: Int, apiKey: String, type: GooglePlaceType?) -> String
    func getGoogleGeocodeURLStr(latitude: Double, longitude: Double, apiKey: String) -> String
    func getPlaceDetailsURLStr(placeId: String, fields: String, apiKey: String) -> String
}

extension MapServiceURL {
    func getNearBySearchResultsURLStr(query: String, coordinate: CLLocationCoordinate2D, radius: Int, apiKey: String, type: GooglePlaceType? = nil) -> String {
        return "\(Constants.googleMapsBaseURL)\(GooglePlacesAPIEndpoints.nearBySearch.rawValue)/json?" +
               "keyword=\(query)" +
               "&location=\(coordinate.latitude)%\(coordinate.longitude)" +
               "&radius=\(radius)" +
               "\(type != nil ? "&type=\(String(describing: type!.rawValue))" : "")" +
               "&key=\(apiKey)"
            
    }
    
    func getAutoCompletePlacesURLStr(query: String, coordinate: CLLocationCoordinate2D, radius: Int, apiKey: String, type: GooglePlaceType?) -> String {
        return "\(Constants.googleMapsBaseURL)\(GooglePlacesAPIEndpoints.autoComplete.rawValue)/json?" +
               "input=\(query)" +
               "&location=\(coordinate.latitude)%\(coordinate.longitude)" +
               "&radius=\(radius)" +
               "\(type != nil ? "&type=\(String(describing: type!.rawValue))" : "")" +
               "&key=\(apiKey)"
    }
    
    func getGoogleGeocodeURLStr(latitude: Double, longitude: Double, apiKey: String) -> String {
        "\(Constants.googleGeocodeBaseURL)json?latlng=\(latitude),\(longitude)&key=\(apiKey)"
    }
    
    func getPlaceDetailsURLStr(placeId: String, fields: String, apiKey: String) -> String {
        return "\(Constants.googlePlacesBaseURL)\(placeId)" +
               "?fields=\(fields)" +
               "&key=\(apiKey)"
    }
}

class MapsService: MapServiceURL {
    var region: MKCoordinateRegion?
    let networkManager: Networking
    var locationManager: LocationManager?
    var apiKeyManager: ApiKeyManager
    var cancellables = Set<AnyCancellable>()
    var locationCancellable: AnyCancellable?
    
    init(networkManager: Networking = NetworkManager(), apiKeyManager: ApiKeyManager = ApiKeyManager()) {
        self.networkManager = networkManager
        self.apiKeyManager = apiKeyManager
    }

    func getNearbySearchResults(query: String, radius: Int, type: GooglePlaceType? = nil) async throws -> GoogleNearbySearchModel? {
        do {
            let apiKey = try apiKeyManager.getGoogleApiKey()
            if let coordinate = locationManager?.center?.center {
                let urlStr = getNearBySearchResultsURLStr(query: query, 
                                                          coordinate: coordinate,
                                                          radius: radius,
                                                          apiKey: apiKey,
                                                          type: type)

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
            let apiKey = try apiKeyManager.getGoogleApiKey()
            if let region = locationManager?.center {
                let coordinate = region.center
                let urlStr = getAutoCompletePlacesURLStr(query: query, 
                                                         coordinate: coordinate,
                                                         radius: radius,
                                                         apiKey: apiKey,
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
            let apiKey = try apiKeyManager.getGoogleApiKey()
            let urlStr = getGoogleGeocodeURLStr(latitude: latitude, longitude: longitude, apiKey: apiKey)
            
            guard let url = URL(string: urlStr) else { return nil }
            
            let retVal = try await networkManager.get(url: url, type: ReverseGeocodeModel.self)
            
            return retVal
        } catch {
            throw error
        }
    }
    
    func getLocationDetails(placeId: String, fields: String = "location,displayName,id,formattedAddress") async throws -> GooglePlaceDetailsModel? {
        do {
            let apiKey = try apiKeyManager.getGoogleApiKey()
            let urlStr = getPlaceDetailsURLStr(placeId: placeId, fields: fields, apiKey: apiKey)
            
            guard let url = URL(string: urlStr) else { return nil }
            
            let retVal = try await networkManager.get(url: url, type: GooglePlaceDetailsModel.self)
            
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
