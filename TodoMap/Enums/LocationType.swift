//
//  LocationType.swift
//  TodoMap
//
//  Created by Suguru on 9/11/23.
//

import Foundation

enum LocationType: String, Codable {
    case approximate = "APPROXIMATE"
    case geometricCenter = "GEOMETRIC_CENTER"
    case rooftop = "ROOFTOP"
}
