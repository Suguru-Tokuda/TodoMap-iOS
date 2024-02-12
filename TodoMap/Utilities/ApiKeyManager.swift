//
//  ApiKeyManager.swift
//  TodoMap
//
//  Created by Suguru Tokuda on 2/12/24.
//

import Foundation

protocol PlistActions {
    func getData<T: Decodable>(resource: String, type: T.Type) throws -> T
}

extension PlistActions {
    func getData<T: Decodable>(resource: String = "ApiKeys", type: T.Type = ApiKeyModel.self) throws -> T {
        do {
            if let url = Bundle.main.url(forResource: resource, withExtension: "plist") {
                var data: Data
                
                do {
                    data = try Data(contentsOf: url)
                } catch {
                    throw PlistError.url
                }
                
                do {
                    let retVal = try PropertyListDecoder().decode(type.self, from: data)
                    return retVal
                } catch {
                    throw PlistError.parse
                }
            } else {
                throw PlistError.url
            }
        } catch {
            throw PlistError.url
        }
    }
}

protocol ApiKeyActions {
    func getGoogleApiKey() throws -> String
}

class ApiKeyManager: PlistActions, ApiKeyActions {
    func getGoogleApiKey() throws -> String {
        do {
            let apiKeyModel = try self.getData()
            return apiKeyModel.googleApiKey
        } catch {
            throw PlistError.dataNotFound
        }
    }
}
