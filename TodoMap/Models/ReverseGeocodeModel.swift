//
//  ReverseGeocodeModel.swift
//  TodoMap
//
//  Created by Suguru on 9/11/23.
//

import Foundation

// MARK: - ReverseGeocodeModel
struct ReverseGeocodeModel: Decodable {
    let plusCode: PlusCode
    let results: [Result]
    let status: String

    enum CodingKeys: String, CodingKey {
        case plusCode = "plus_code"
        case results, status
    }
}

struct PlusCode: Decodable {
    let compoundCode, globalCode: String

    enum CodingKeys: String, CodingKey {
        case compoundCode = "compound_code"
        case globalCode = "global_code"
    }
}

struct Result: Decodable {
    let addressComponents: [AddressComponent]
    let formattedAddress: String
    let geometry: Geometry
    let placeId: String
    let plusCode: PlusCode?
    let types: [String]

    enum CodingKeys: String, CodingKey {
        case addressComponents = "address_components"
        case formattedAddress = "formatted_address"
        case geometry
        case placeId = "place_id"
        case plusCode = "plus_code"
        case types
    }
}

struct AddressComponent: Decodable {
    let longName, shortName: String
    let types: [String]

    enum CodingKeys: String, CodingKey {
        case longName = "long_name"
        case shortName = "short_name"
        case types
    }
}
