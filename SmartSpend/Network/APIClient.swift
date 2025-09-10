////
////  APIClient.swift
////  SmartSpend
////
////  Created by Refik Jaija on 20.8.25.
////
//
//import Foundation
//
//class APIClient {
//    static let shared = APIClient()
//    private init() {}
//
//    private let baseURL = URL(string: "https://96aed091191d.ngrok-free.app/")!
//
//    func request<T: Decodable>(
//        endpoint: String,
//        method: String = "GET",
//        body: Encodable? = nil
//    ) async throws -> T {
//
//        guard let url = URL(string: endpoint, relativeTo: baseURL) else {
//            throw URLError(.badURL)
//        }
//
//        var urlRequest = URLRequest(url: url)
//        urlRequest.httpMethod = method
//        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
//
//        // Inject Bearer token
//        if let token = await TokenManager.shared.accessToken  {
//            urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
//        }
//
//        // Encode body if present
//        if let body = body {
//            urlRequest.httpBody = try JSONEncoder().encode(body)
//        }
//
//        let (data, response) = try await URLSession.shared.data(for: urlRequest)
//
//        guard let httpResponse = response as? HTTPURLResponse else {
//            throw URLError(.badServerResponse)
//        }
//
//        // Handle 401 (expired access token → refresh flow)
//        if httpResponse.statusCode == 401 {
//            try await TokenManager.shared.refreshAccessToken()
//            return try await request(endpoint: endpoint, method: method, body: body)
//        }
//        
////        1. do api call
////        1. use access token
////        if ok
////            continue
////        else
////            use refresh token to get new access
////                if ok
////                    save new access -> continei
////                else
////                    force logout screen
//                    
//
//        guard (200...299).contains(httpResponse.statusCode) else {
//            throw NSError(domain: "", code: httpResponse.statusCode, userInfo: nil)
//        }
//
//        return try JSONDecoder().decode(T.self, from: data)
//    }
//}
//


//
//  APIClient.swift
//  SmartSpend
//
//  Created by Refik Jaija on 20.8.25.
//

import Foundation

class APIClient {
    static let shared = APIClient()
    private init() {}

    private let baseURL = URL(string: "https://7906c6ac2a58.ngrok-free.app/")!

    func request<T: Decodable>(
        endpoint: String,
        method: String = "GET",
        body: Encodable? = nil
    ) async throws -> T {

        guard let url = URL(string: endpoint, relativeTo: baseURL) else {
            throw URLError(.badURL)
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // UPDATED: Inject Bearer token for protected endpoints (exclude auth endpoints)
        if !endpoint.contains("/api/auth") {
            if let token = await TokenManager.shared.accessToken {
                urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            }
        }

        // Encode body if present
        if let body = body {
            urlRequest.httpBody = try JSONEncoder().encode(body)
        }

        let (data, response) = try await URLSession.shared.data(for: urlRequest)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }

        // UPDATED: Handle 401 (expired access token → refresh flow) but not for auth endpoints
        if httpResponse.statusCode == 401 && !endpoint.contains("/api/auth") {
            do {
                try await TokenManager.shared.refreshAccessToken()
                
                // Retry original request with new token
                if let newToken = await TokenManager.shared.accessToken {
                    urlRequest.setValue("Bearer \(newToken)", forHTTPHeaderField: "Authorization")
                    let (retryData, retryResponse) = try await URLSession.shared.data(for: urlRequest)
                    
                    guard let retryHttpResponse = retryResponse as? HTTPURLResponse else {
                        throw URLError(.badServerResponse)
                    }
                    
                    guard (200...299).contains(retryHttpResponse.statusCode) else {
                        throw NSError(domain: "", code: retryHttpResponse.statusCode, userInfo: nil)
                    }
                    
                    return try JSONDecoder().decode(T.self, from: retryData)
                }
            } catch RefreshTokenError.refreshTokenExpired {
                // NEW: Refresh token expired - need to sign in again
                // Post notification for logout
                NotificationCenter.default.post(name: .refreshTokenExpired, object: nil)
                throw RefreshTokenError.refreshTokenExpired
            }
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            throw NSError(domain: "", code: httpResponse.statusCode, userInfo: nil)
        }

        return try JSONDecoder().decode(T.self, from: data)
    }
}

// NEW: Notification for handling refresh token expiration
extension Notification.Name {
    static let refreshTokenExpired = Notification.Name("refreshTokenExpired")
}
