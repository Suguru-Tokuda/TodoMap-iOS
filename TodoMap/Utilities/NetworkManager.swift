//
//  NetworkManager.swift
//  TodoMap
//
//  Created by Suguru on 8/21/23.
//

import Foundation

protocol Networking {
    func get<T: Decodable>(url: URL, type: T.Type, method: HTTPMethod) async throws -> T
    func getRequest(url: URL, method: HTTPMethod, headers: [String: String]?) -> URLRequest
}

extension Networking {
    func get<T: Decodable>(url: URL, type: T.Type, method: HTTPMethod = .get) async throws -> T {
        do {
            let request = getRequest(url: url, method: .get)
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let res = response as? HTTPURLResponse,
                  200..<300 ~= res.statusCode else {
                throw NetworkError.badServerResponse
            }
            
            do {
                let parsedData = try JSONDecoder().decode(type.self, from: data)
                return parsedData
            } catch {
                throw NetworkError.parse
            }
            
        } catch {
            throw NetworkError.unknown
        }

    }

    func getRequest(url: URL, method: HTTPMethod = .get, headers: [String: String]? = nil) -> URLRequest {
        var request = URLRequest(url: url)
        
        request.cachePolicy = .reloadRevalidatingCacheData
        request.httpMethod = method.rawValue
        
        // Set headers
        if let headers {
            headers.forEach { (key, value) in request.setValue(value, forHTTPHeaderField: key)}
        }
        
        return request
    }
}

class NetworkManager: Networking {
}
