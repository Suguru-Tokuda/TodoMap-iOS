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
    let cityName: String?
    let coordinates: CLLocationCoordinate2D
    let description: String?
    let imageNames: [String]?
    let link: String?
    
    init(name: String, coordinates: CLLocationCoordinate2D) {
        self.name = name
        self.coordinates = coordinates
        self.cityName = ""
        self.description = ""
        self.imageNames = []
        self.link = ""
    }
}
