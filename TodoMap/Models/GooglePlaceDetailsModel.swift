//
//  GooglePlaceDetailsModel.swift
//  TodoMap
//
//  Created by Suguru Tokuda on 2/17/24.
//

import Foundation

struct GooglePlaceDetailsModel: Decodable {
    var id: UUID { UUID() }
    let placeId: String
    let formattedAddress: String
    let location: GooglePlaceDetailsLocationModel
    let displayName: DisplayNameModel
    
    enum CodingKeys: String, CodingKey {
        case placeId = "id",
             formattedAddress,
             location,
             displayName
    }
}

struct GooglePlaceDetailsLocationModel: Decodable {
    let latitude, longitude: Double
}

struct DisplayNameModel: Decodable {
    let text: String
}
