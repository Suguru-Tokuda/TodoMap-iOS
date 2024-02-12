//
//  PlistError.swift
//  TodoMap
//
//  Created by Suguru Tokuda on 2/12/24.
//

import Foundation

enum PlistError: String, Error {
    case parse,
         url,
         path,
         dataNotFound
}

extension PlistError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .parse:
            return NSLocalizedString(self.rawValue, comment: "Error in parsing a PList.")
        case .url:
            return NSLocalizedString(self.rawValue, comment: "Error in finding a url.")
        case .path:
            return NSLocalizedString(self.rawValue, comment: "Error in finding a path.")
        case .dataNotFound:
            return NSLocalizedString(self.rawValue, comment: "No PList.")
        }
    }
}
