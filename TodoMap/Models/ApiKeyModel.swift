//
//  ApiKeyModel.swift
//  TodoMap
//
//  Created by Suguru Tokuda on 2/12/24.
//

import Foundation

struct ApiKeyModel: Decodable {
    let googleApiKey: String
    
    enum CodingKeys: String, CodingKey {
        case googleApiKey = "GOOGLE_API_KEY"
    }
}
