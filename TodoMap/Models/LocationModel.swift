//
//  LocationModel.swift
//  TodoMap
//
//  Created by Suguru on 8/8/23.
//

import Foundation
import MapKit

struct LocationModel {
    let name: String
    let coordinates: CLLocationCoordinate2D
    let description: String?
    
    init(name: String, coordinates: CLLocationCoordinate2D) {
        self.name = name
        self.coordinates = coordinates
        self.description = ""
    }
}
