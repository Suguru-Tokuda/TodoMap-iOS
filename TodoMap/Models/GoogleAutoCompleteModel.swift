//
//  GoogleAutoCompleteModel.swift
//  TodoMap
//
//  Created by Suguru on 8/21/23.
//

import Foundation

struct GoogleAutoCompleteModel: Codable {
    var predictions: [Prediction]?
    var status: String?
}

// MARK: - Prediction
struct Prediction: Codable, Hashable, Identifiable {
    var id: UUID = UUID()
    var description: String?
    var matchedSubstrings: [MatchedSubstring]?
    var placeId: String
    var reference: String?
    var structuredFormatting: StructuredFormatting?
    var terms: [Term]?
    var types: [String]?

    enum CodingKeys: String, CodingKey {
        case description
        case matchedSubstrings = "matched_substrings"
        case placeId = "place_id"
        case reference
        case structuredFormatting = "structured_formatting"
        case terms, types
    }
    
    static func == (lhs: Prediction, rhs: Prediction) -> Bool {
        lhs.id != rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

// MARK: - MatchedSubstring
struct MatchedSubstring: Codable {
    var length, offset: Int?
}

// MARK: - StructuredFormatting
struct StructuredFormatting: Codable {
    var mainText: String?
    var mainTextMatchedSubstrings: [MatchedSubstring]?
    var secondaryText: String?

    enum CodingKeys: String, CodingKey {
        case mainText = "main_text"
        case mainTextMatchedSubstrings = "main_text_matched_substrings"
        case secondaryText = "secondary_text"
    }
}

// MARK: - Term
struct Term: Codable {
    var offset: Int?
    var value: String?
}
