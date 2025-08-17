//
//  AuthNetworking.swift
//  SmartSpend
//
//  Created by shortcut mac on 17.8.25.
//

import Foundation

protocol AuthNetworking {
    /// Sends provider token to backend. Returns app session token (JWT) or nil.
    func sendProviderToken(_ token: ProviderToken) async throws -> String?
}

/// Simple mock used for frontend-only testing / previewing UI.
final class MockAuthNetworking: AuthNetworking {
    func sendProviderToken(_ token: ProviderToken) async throws -> String? {
        // simulate network latency
        try await Task.sleep(nanoseconds: 600_000_000) // 0.6s
        return "mock-session-token-abc123"
    }
}

/// Remote networking skeleton — replace with your real endpoint details.
final class RemoteAuthNetworking: AuthNetworking {
    private let baseURL: URL

    init(baseURL: URL = AuthConstants.backendBaseURL) {
        self.baseURL = baseURL
    }

    func sendProviderToken(_ token: ProviderToken) async throws -> String? {
        let url = baseURL.appendingPathComponent(AuthConstants.authEndpointPath)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let payload: [String: Any?] = [
            "provider": token.provider,
            "id_token": token.idToken,
            "authorization_code": token.authorizationCode,
            "raw_nonce": token.rawNonce,
            "user_id": token.userID
        ]

        request.httpBody = try JSONSerialization.data(withJSONObject: payload.compactMapValues { $0 }, options: [])

        let (data, response) = try await URLSession.shared.data(for: request)
        guard let http = response as? HTTPURLResponse, (200...299).contains(http.statusCode) else {
            let body = String(data: data, encoding: .utf8) ?? ""
            throw NSError(domain: "RemoteAuthNetworking", code: 1, userInfo: [NSLocalizedDescriptionKey: "status \((response as? HTTPURLResponse)?.statusCode ?? -1): \(body)"])
        }

        if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
           let sessionToken = json["session_token"] as? String {
            return sessionToken
        }
        return nil
    }
}










//import Foundation
//
//protocol AuthNetworking {
//    func sendProviderToken(_ token: ProviderToken) async throws -> String?
//}
//
//final class MockAuthNetworking: AuthNetworking {
//    func sendProviderToken(_ token: ProviderToken) async throws -> String? {
//        try await Task.sleep(nanoseconds: 600_000_000)
//        return "mock-session-token-abc123"
//    }
//}

/* Remote implementation example (uncomment & implement)
final class RemoteAuthNetworking: AuthNetworking {
    private let baseURL: URL
    init(baseURL: URL = AuthConstants.backendBaseURL) { self.baseURL = baseURL }

    func sendProviderToken(_ token: ProviderToken) async throws -> String? {
        let url = baseURL.appendingPathComponent(AuthConstants.authEndpointPath)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let payload: [String: Any?] = [
            "provider": token.provider,
            "id_token": token.idToken,
            "authorization_code": token.authorizationCode,
            "raw_nonce": token.rawNonce,
            "user_id": token.userID
        ]
        request.httpBody = try JSONSerialization.data(withJSONObject: payload.compactMapValues { $0 }, options: [])

        let (data, response) = try await URLSession.shared.data(for: request)
        guard let http = response as? HTTPURLResponse, (200...299).contains(http.statusCode) else {
            let body = String(data: data, encoding: .utf8) ?? ""
            throw NSError(domain: "AuthNetworking", code: 1, userInfo: [NSLocalizedDescriptionKey: body])
        }
        if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
           let sessionToken = json["session_token"] as? String {
            return sessionToken
        }
        return nil
    }
}
*/
