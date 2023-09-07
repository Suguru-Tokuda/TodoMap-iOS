//
//  MKCoordinateRegion.swift
//  TodoMap
//
//  Created by Suguru on 9/3/23.
//

import MapKit

extension MKCoordinateRegion {
    /**
        The return value  is in meters between the current location and the destination
     */
    func getDistance(latitude: Double, longitude: Double) -> Double {
        let currentLocation = CLLocation(latitude: self.center.latitude, longitude: self.center.longitude)
        let destination = CLLocation(latitude: latitude, longitude: longitude)
        return Double(currentLocation.distance(from: destination))
    }
}
