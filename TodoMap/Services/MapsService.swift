//
//  GoogleMapsService.swift
//  TodoMap
//
//  Created by Suguru on 8/21/23.
//

import MapKit

class MapsService {
    static let shared = MapsService()
    static let googleMapsBaseURL = "\(Constants.googleAPIBaseURL)maps/api/place/"
    var region: MKCoordinateRegion = MKCoordinateRegion(center: MapDetails.startingLocation, span: MapDetails.defaultSpan)
    
    init() {
        region = LocationService.shared.mapRegion
        addSubscription()
    }
    
    private func addSubscription() {
        Task {
            for await value in LocationService.shared.$mapRegion.values {
                await MainActor.run(body: {
                    self.region = value
                })
            }
        }
    }
    
    func getNearbySearchResults(query: String, radius: Int, type: GooglePlaceType? = nil) async throws -> GoogleNearbySearchModel? {
        do {
            let coordinate = region.center
            let urlStr = "\(MapsService.googleMapsBaseURL)nearbysearch/json?keyword=\(query)&location=\(coordinate.latitude),\(coordinate.longitude)&radius=\(radius)\(type != nil ? "&type=\(String(describing: type!.rawValue))" : "")&key=\(Keys.googleAPIKey)"

            guard let url = URL(string: urlStr)
            else { return nil }
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
            let urlStr = "\(MapsService.googleMapsBaseURL)autocomplete/json?input=\(query)&location=\(coordinate.latitude),\(coordinate.longitude)&radius=\(radius)\(type != nil ? "&type=\(String(describing: type?.rawValue))" : "")&key=\(Keys.googleAPIKey)"
            
            guard let url = URL(string: urlStr)
            else { return nil }
            if let data = try? await NetworkingManager.get(url: url) {
                return try JSONDecoder().decode(GoogleAutoCompleteModel.self, from: data)
            } else {
                return nil
            }
        } catch {
            throw error
        }
    }
    
    
}
