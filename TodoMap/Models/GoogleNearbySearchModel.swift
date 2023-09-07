//
//  GoogleNearbySearchModel.swift
//  TodoMap
//
//  Created by Suguru on 9/2/23.
//

import Foundation

import Foundation

// MARK: - GoogleNearbySearchModel
struct GoogleNearbySearchModel: Codable {
    var results: [NearbySearchResult]?
    var status: String?

    enum CodingKeys: String, CodingKey {
        case results, status
    }
}

// MARK: - Result
struct NearbySearchResult: Codable, Hashable, Identifiable {
    var id: UUID = UUID()
    var businessStatus: String?
    var geometry: Geometry?
    var icon: String?
    var iconBackgroundColor: String?
    var iconMaskBaseURI: String?
    var name: String?
    var openingHours: OpeningHours?
    var photos: [Photo]?
    var placeId: String?
    var priceLevel: Int?
    var rating: Double?
    var reference: String?
    var types: [String]?
    var userRatingsTotal: Int?
    var vicinity: String?
    var distanceInMeter: Double? = 0

    enum CodingKeys: String, CodingKey {
        case businessStatus = "business_status"
        case geometry, icon
        case iconBackgroundColor = "icon_background_color"
        case iconMaskBaseURI = "icon_mask_base_uri"
        case name
        case openingHours = "opening_hours"
        case photos
        case placeId = "place_id"
        case priceLevel = "price_level"
        case rating, reference, types
        case userRatingsTotal = "user_ratings_total"
        case vicinity
    }
    
    static func == (lhs: NearbySearchResult, rhs: NearbySearchResult) -> Bool {
        lhs.id != rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

// MARK: - Geometry
struct Geometry: Codable {
    var location: Location?
    var viewport: Viewport?
}

// MARK: - Location
struct Location: Codable {
    var lat, lng: Double
}

// MARK: - Viewport
struct Viewport: Codable {
    var northeast, southwest: Location?
}

// MARK: - OpeningHours
struct OpeningHours: Codable {
    var openNow: Bool?

    enum CodingKeys: String, CodingKey {
        case openNow = "open_now"
    }
}

// MARK: - Photo
struct Photo: Codable {
    var height: Int?
    var photoReference: String?
    var width: Int?

    enum CodingKeys: String, CodingKey {
        case height
        case photoReference = "photo_reference"
        case width
    }
}
