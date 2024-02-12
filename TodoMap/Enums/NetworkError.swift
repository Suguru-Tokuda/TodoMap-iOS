//
//  NetworkError.swift
//  TodoMap
//
//  Created by Suguru Tokuda on 2/9/24.
//

import Foundation

enum NetworkError: String, Error {
    case noData,
         badUrl,
         parse,
         badServerResponse,
         unknown
}

extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .noData:
            return NSLocalizedString(self.rawValue, comment: "No Data")
        case .badUrl:
            return NSLocalizedString(self.rawValue, comment: "Bad url")
        case .parse:
            return NSLocalizedString(self.rawValue, comment: "Parse")
        case .badServerResponse:
            return NSLocalizedString(self.rawValue, comment: "Bad server response")
        case .unknown:
            return NSLocalizedString(self.rawValue, comment: "Unknown")
        }
    }
}
