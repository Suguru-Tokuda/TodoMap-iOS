//
//  MapError.swift
//  TodoMap
//
//  Created by Suguru Tokuda on 2/10/24.
//

import Foundation

enum LocationError: String, Error {
    case unauthorized,
         denied,
         restricted
}

extension LocationError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .unauthorized:
            return NSLocalizedString(self.rawValue, comment: "Location serice is not authorized.")
        case .denied:
            return NSLocalizedString(self.rawValue, comment: "Location service is denied.")
        case .restricted:
            return NSLocalizedString(self.rawValue, comment: "Location service is restricted")
        }
    }
}
