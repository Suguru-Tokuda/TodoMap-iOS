//
//  CoreDataError.swift
//  TodoMap
//
//  Created by Suguru Tokuda on 2/9/24.
//

import Foundation

enum CoreDataError: String, Error {
    case save,
         get,
         delete
}

extension CoreDataError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .save:
            return NSLocalizedString(self.rawValue, comment: "Save error")
        case .get:
            return NSLocalizedString(self.rawValue, comment: "Get error")
        case .delete:
            return NSLocalizedString(self.rawValue, comment: "Delete error")
        }
    }
}
