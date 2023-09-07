//
//  NetworkManager.swift
//  TodoMap
//
//  Created by Suguru on 8/21/23.
//

import Foundation

class NetworkingManager {
    enum NetworkingError: LocalizedError {
        case badURLResponse(url: URL)
        case unknown
        
        var errorDescription: String? {
            switch self {
            case .badURLResponse(url: let url): return "Bad response from URL. \(url)"
            case .unknown: return "Unknown error occured."
            }
        }
    }
    
    static func get(url: URL) async throws -> Data? {
        do {
            let request = getRequest(url: url, httpMethod: "GET")
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let response = response as? HTTPURLResponse,
                  response.statusCode >= 200 && response.statusCode < 300 else {
                throw NetworkingError.badURLResponse(url: url)
            }

            return data
        } catch {
            throw error
        }
    }
    
    private static func getRequest(url: URL, httpMethod: String = "GET", headers: [String: String]? = nil) -> URLRequest {
        var request = URLRequest(url: url)
        
        request.cachePolicy = .reloadRevalidatingCacheData
        request.httpMethod = httpMethod.uppercased()
        
        // Set headers
        if let headers = headers {
            headers.forEach { (key, value) in request.setValue(value, forHTTPHeaderField: key)}
        }
        
        return request
    }
}
