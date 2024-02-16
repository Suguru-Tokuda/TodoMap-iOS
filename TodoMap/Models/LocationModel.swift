//
//  LocationModel.swift
//  TodoMap
//
//  Created by Suguru on 8/8/23.
//

import Foundation
import MapKit

struct LocationModel {
    let id: UUID
    let name: String
    let coordinates: CLLocationCoordinate2D
    let description: String?
    
    init(name: String, coordinates: CLLocationCoordinate2D) {
        self.id = UUID()
        self.name = name
        self.coordinates = coordinates
        self.description = ""
    }
    
    init?(from entity: LocationEntity?) {
        if let entity = entity,
           let id = entity.id,
           let name = entity.name {
            self.id = id
            self.name = name
            self.coordinates = CLLocationCoordinate2D(latitude: entity.latitude, longitude: entity.longitutde)
            self.description = entity.description
        } else {
            return nil
        }
    }
}
