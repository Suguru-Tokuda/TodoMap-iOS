//
//  GoogleMapsService.swift
//  TodoMap
//
//  Created by Suguru on 8/21/23.
//

import MapKit

class MapsService {
    static let shared = MapsService()
    let googleMapsBaseURL = "\(Constants.googleAPIBaseURL)maps/api/place/"
    let googleGeocodeBaseURL = "\(Constants.googleAPIBaseURL)maps/api/geocode/"
    var region: MKCoordinateRegion = MKCoordinateRegion(center: MapDetails.startingLocation, span: MapDetails.defaultSpan)
    
    init() {
        if let region = LocationService.shared.center {
            self.region = region
        }        
        addSubscription()
    }
    
    private func addSubscription() {
        Task {
            for await value in LocationService.shared.$center.values {
                await MainActor.run(body: {
                    if let value = value {
                        self.region = value
                    }
                })
            }
        }
    }
    
    func getNearbySearchResults(query: String, radius: Int, type: GooglePlaceType? = nil) async throws -> GoogleNearbySearchModel? {
        do {
            let coordinate = region.center
            let urlStr = "\(googleMapsBaseURL)nearbysearch/json?keyword=\(query)&location=\(coordinate.latitude),\(coordinate.longitude)&radius=\(radius)\(type != nil ? "&type=\(String(describing: type!.rawValue))" : "")&key=\(Keys.googleAPIKey)"

            guard let url = URL(string: urlStr) else { return nil }
            if let data = try? await NetworkingManager.get(url: url) {
                var retVal = try JSONDecoder().decode(GoogleNearbySearchModel.self, from: data)
                
                if var results = retVal.results {
                    for i in 0..<results.count {
                        let result = results[i]
                        if let geometry = result.geometry,
                           let location = geometry.location {
                            results[i].distanceInMeter = self.region.getDistance(latitude: location.lat, longitude: location.lng)
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
            let coordinate = region.center
            let urlStr = "\(googleMapsBaseURL)autocomplete/json?input=\(query)&location=\(coordinate.latitude),\(coordinate.longitude)&radius=\(radius)\(type != nil ? "&type=\(String(describing: type?.rawValue))" : "")&key=\(Keys.googleAPIKey)"
            
            guard let url = URL(string: urlStr) else { return nil }
            if let data = try? await NetworkingManager.get(url: url) {
                return try JSONDecoder().decode(GoogleAutoCompleteModel.self, from: data)
            } else {
                return nil
            }
        } catch {
            throw error
        }
    }
    
    func getLocation(latitude: Double, longitude: Double) async throws -> ReverseGeocodeModel? {
        do {
            let urlStr = "\(googleGeocodeBaseURL)json?latlng=\(latitude),\(longitude)&key=\(Keys.googleAPIKey)"
            
            guard let url = URL(string: urlStr) else { return nil }
            
            if let data = try? await NetworkingManager.get(url: url) {
                return try JSONDecoder().decode(ReverseGeocodeModel.self, from: data)
            } else {
                return nil
            }
        } catch {
            throw error
        }
    }
}
