//
//  APIClient.swift
//  SmartSpend
//
//  Created by Refik Jaija on 20.8.25.

//
//import Foundation
//
//class APIClient {
//    static let shared = APIClient()
//    private init() {}
//
//    private let baseURL = URL(string: "https://7c91f8c7b921.ngrok-free.app/")!
//
//    func request<T: Decodable>(
//        endpoint: String,
//        method: String = "GET",
//        headers: [String: String]? = nil,
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
//            if headers?["Authorization"] == nil {
//                urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
//            }
//        }
//        
//        // Apply any explicit headers from caller (they override defaults above)
//        if let headers = headers {
//            for (k, v) in headers {
//                urlRequest.setValue(v, forHTTPHeaderField: k)
//            }
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
////        if httpResponse.statusCode == 401 {
////            if allowRefreshOn401 {
////                // Attempt to refresh once, then retry the request but do NOT allow further refresh attempts
////                try await TokenManager.shared.refreshAccessToken()
////                return try await request(endpoint: endpoint, method: method, headers: headers, body: body, allowRefreshOn401: false)
////            } else {
////                // Do not attempt to refresh again (prevents recursion). Surface an auth error.
////                throw URLError(.userAuthenticationRequired)
////            }
////        }
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
////        return try JSONDecoder().decode(T.self, from: data)
//        
//        do {
//            return try JSONDecoder().decode(T.self, from: data)
//        } catch {
//            let bodyStr = String(data: data, encoding: .utf8) ?? "<non-utf8 response>"
//            print(" Decoding error: \(error)\nRaw response body:\n\(bodyStr)")
//            throw error
//        }
//    }
//}




//--------------------------------------------------------------------------------------------------//

//  APIClient.swift
//  SmartSpend
//
//  Created by Refik Jaija on 20.8.25.

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



import Foundation

class APIClient {
    static let shared = APIClient()
    private init() {}

    private let baseURL = URL(string: "https://c7624a78d6d2.ngrok-free.app/")!

    // Generic request that retries once on 401
    func request<T: Decodable>(
        endpoint: String,
        method: String = "GET",
        body: Encodable? = nil
    ) async throws -> T {

        do {
            return try await performRequest(endpoint: endpoint, method: method, body: body, allowRetry: true)
        } catch {
            throw error
        }
    }

    // Lower-level request
    private func performRequest<T: Decodable>(
        endpoint: String,
        method: String,
        body: Encodable?,
        allowRetry: Bool
    ) async throws -> T {

        guard let url = URL(string: endpoint, relativeTo: baseURL) else {
            throw URLError(.badURL)
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // Add current access token
        if let token = await TokenManager.shared.accessToken {
            urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        if let body = body {
            urlRequest.httpBody = try JSONEncoder().encode(body)
        }

        let (data, response) = try await URLSession.shared.data(for: urlRequest)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }

        if httpResponse.statusCode == 401, allowRetry {
            // refresh token
            try await TokenManager.shared.refreshAccessToken()
            // retry once with new token
            return try await performRequest(endpoint: endpoint, method: method, body: body, allowRetry: false)
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            throw NSError(domain: "", code: httpResponse.statusCode, userInfo: nil)
        }

        return try JSONDecoder().decode(T.self, from: data)
    }

    // Raw request for refresh calls (no auto-refresh)
    func rawRequest<T: Decodable>(
        endpoint: String,
        method: String,
        headers: [String: String],
        body: Encodable? = nil
    ) async throws -> T {
        guard let url = URL(string: endpoint, relativeTo: baseURL) else {
            throw URLError(.badURL)
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")

        for (k, v) in headers {
            urlRequest.setValue(v, forHTTPHeaderField: k)
        }

        if let body = body {
            urlRequest.httpBody = try JSONEncoder().encode(body)
        }

        let (data, response) = try await URLSession.shared.data(for: urlRequest)

        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }

        return try JSONDecoder().decode(T.self, from: data)
    }
}
