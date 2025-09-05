//
//  TokenManager.swift
//  SmartSpend
//
//  Created by Refik Jaija on 20.8.25.
//
// Network/TokenManager.swift
//import Foundation
//import Security
//
//actor TokenManager {
//    static let shared = TokenManager()
//
//    private(set) var accessToken: String?
//    private(set) var refreshToken: String?
//
//    func saveTokens(access: String, refresh: String) {
//        self.accessToken = access
//        self.refreshToken = refresh
//        KeychainHelper.standard.save(access, service: "SmartSpend", account: "accessToken")
//        KeychainHelper.standard.save(refresh, service: "SmartSpend", account: "refreshToken")
//    }
//    func clearTokens() async {
//        KeychainHelper.standard.delete(service: "SmartSpend", account: "accessToken")
//        KeychainHelper.standard.delete(service: "SmartSpend", account: "refreshToken")
//        // Also clear any in-memory tokens if you have them
//    }
//    
//    func loadTokens() {
//        if let access = KeychainHelper.standard.read(service: "SmartSpend", account: "accessToken") {
//            self.accessToken = access
//        }
//        
//        if let refresh = KeychainHelper.standard.read(service: "SmartSpend", account: "refreshToken") {
//            self.refreshToken = refresh
//        }
//    }
//    
//
//    func refreshAccessToken() async throws {
//        // require refresh token at minimum
//        guard let refresh = refreshToken else {
//            throw URLError(.userAuthenticationRequired)
//        }
//
//        struct RefreshResponse: Decodable {
//            let access_token: String
//        }
//
//        let client = APIClient.shared
//
//        // Build headers per your API docs: include Authorization (possibly expired) and Refresh-Token header
//        var headers = [String: String]()
//        if let access = accessToken {
//            headers["Authorization"] = "Bearer \(access)"
//        } else {
//            // If your backend *requires* Authorization header and it's missing, you might need to force re-login.
//            // You can still try without it — many servers accept just the Refresh-Token header.
//            print("Warning: accessToken missing when attempting refresh; continuing with Refresh-Token header only.")
//        }
//        headers["Refresh-Token"] = refresh
//
//        // Call refresh endpoint but do NOT allow APIClient to auto-refresh on 401 (prevents recursion)
//        let response: RefreshResponse = try await client.request(
//            endpoint: "api/token/",
//            method: "POST",
//            headers: headers,
//            body: nil,
//        )
//
//        // Save the new access token
//        self.accessToken = response.access_token
//        KeychainHelper.standard.save(response.access_token, service: "SmartSpend", account: "accessToken")
//    }
//
//
//}


//    func refreshAccessToken() async throws {
//        guard let refresh = refreshToken else { throw URLError(.userAuthenticationRequired) }
//
//        struct RefreshRequest: Encodable {
//        let jwt_token: String
//        }
//        struct RefreshResponse: Decodable {
//        let jwt_token: String
//         }
//
//        let client = APIClient.shared
//        let response: RefreshResponse = try await client.request(
//            endpoint: "api/token/",
//            method: "POST",
//            body: RefreshRequest(jwt_token: refresh)
//        )
//
//        self.accessToken = response.jwt_token
//    }
    
    
//    func refreshAccessToken() async throws {
//        guard let refresh = refreshToken,
//              let access = accessToken else {
//            throw URLError(.userAuthenticationRequired)
//        }
//
//        struct RefreshResponse: Decodable {
//            let access_token: String
//        }
//
//        let client = APIClient.shared
//        let response: RefreshResponse = try await client.request(
//            endpoint: "api/token/",
//            method: "POST",
//            headers: [
//                "Authorization": "Bearer \(access)",
//                "Refresh-Token": refresh
//            ]
//        )
//
//        self.accessToken = response.access_token
//
//        KeychainHelper.standard.save(response.access_token, service: "SmartSpend", account: "accessToken")
//    }
//
    




//  TokenManager.swift
//  SmartSpend
//
//  Created by Refik Jaija on 20.8.25.
//
// Network/TokenManager.swift
//
//import Foundation
//import Security
//
//actor TokenManager {
//    static let shared = TokenManager()
//
//    private(set) var accessToken: String?
//    private(set) var refreshToken: String?
//
//    func saveTokens(access: String, refresh: String) {
//        self.accessToken = access
//        self.refreshToken = refresh
//        KeychainHelper.standard.save(refresh, service: "SmartSpend", account: "refreshToken")
//    }
//
//    func loadTokens() {
//        if let refresh = KeychainHelper.standard.read(service: "SmartSpend", account: "refreshToken") {
//            self.refreshToken = refresh
//        }
//    }
//
//    func refreshAccessToken() async throws {
//        guard let refresh = refreshToken else { throw URLError(.userAuthenticationRequired) }
//
//        struct RefreshRequest: Encodable {
//        let jwt_token: String
//        }
//        struct RefreshResponse: Decodable {
//        let jwt_token: String
//         }
//
//        let client = APIClient.shared
//        let response: RefreshResponse = try await client.request(
//            endpoint: "/auth/refresh-jwt",
//            method: "POST",
//            body: RefreshRequest(jwt_token: refresh)
//        )
//
//        self.accessToken = response.jwt_token
//    }
//}
//
//
//
//


//
//import Foundation
//import Security
//
//actor TokenManager {
//    static let shared = TokenManager()
//
//    private(set) var accessToken: String?
//    private(set) var refreshToken: String?
//
//    func saveTokens(access: String, refresh: String) {
//        self.accessToken = access
//        self.refreshToken = refresh
//        KeychainHelper.standard.save(access, service: "SmartSpend", account: "accessToken")
//        KeychainHelper.standard.save(refresh, service: "SmartSpend", account: "refreshToken")
//    }
//
//    func loadTokens() {
//        if let access = KeychainHelper.standard.read(service: "SmartSpend", account: "accessToken") {
//            self.accessToken = access
//        }
//        if let refresh = KeychainHelper.standard.read(service: "SmartSpend", account: "refreshToken") {
//            self.refreshToken = refresh
//        }
//    }
//
//    func clearTokens() {
//        KeychainHelper.standard.delete(service: "SmartSpend", account: "accessToken")
//        KeychainHelper.standard.delete(service: "SmartSpend", account: "refreshToken")
//        self.accessToken = nil
//        self.refreshToken = nil
//    }
//
//    func refreshAccessToken() async throws {
//        guard let refresh = refreshToken,
//              let access = accessToken else {
//            throw URLError(.userAuthenticationRequired)
//        }
//
//        struct RefreshResponse: Decodable {
//            let access_token: String
//        }
//
//        let client = APIClient.shared
//        let response: RefreshResponse = try await client.rawRequest(
//            endpoint: "api/token",
//            method: "POST",
//            headers: [
//                "Authorization": "Bearer \(access)",
//                "Refresh-Token": refresh
//            ]
//        )
//
//        // Save new access token
//        self.accessToken = response.access_token
//        KeychainHelper.standard.save(response.access_token, service: "SmartSpend", account: "accessToken")
//    }
//}


import Foundation

struct Tokens: Codable {
    let accessToken: String
    let refreshToken: String
    let refreshExpiry: Date
}

actor TokenManager {
    static let shared = TokenManager()

    private(set) var tokens: Tokens?

    func saveTokens(access: String, refresh: String, expiry: Date) {
        let tokens = Tokens(accessToken: access, refreshToken: refresh, refreshExpiry: expiry)
        self.tokens = tokens

        // Persist each field
        KeychainHelper.standard.save(access, service: "SmartSpend", account: "accessToken")
        KeychainHelper.standard.save(refresh, service: "SmartSpend", account: "refreshToken")
        KeychainHelper.standard.save(String(expiry.timeIntervalSince1970),
                                     service: "SmartSpend", account: "refreshExpiry")
        
        print("✅ Tokens saved to Keychain")

    }

//    func loadTokens() {
//        guard
//            let access = KeychainHelper.standard.read(service: "SmartSpend", account: "accessToken"),
//            let refresh = KeychainHelper.standard.read(service: "SmartSpend", account: "refreshToken"),
//            let expiryStr = KeychainHelper.standard.read(service: "SmartSpend", account: "refreshExpiry"),
//            let expiryTimestamp = TimeInterval(expiryStr)
//        else {
//            self.tokens = nil
//            return
//        }
//
//        self.tokens = Tokens(accessToken: access, refreshToken: refresh, refreshExpiry: Date(timeIntervalSince1970: expiryTimestamp))
//    }
    
    func loadTokens() {
        let access = KeychainHelper.standard.read(service: "SmartSpend", account: "accessToken")
        let refresh = KeychainHelper.standard.read(service: "SmartSpend", account: "refreshToken")
        let expiryStr = KeychainHelper.standard.read(service: "SmartSpend", account: "refreshExpiry")

        print("🔑 Loaded access:", access ?? "nil")
        print("🔑 Loaded refresh:", refresh ?? "nil")
        print("🔑 Loaded expiry:", expiryStr ?? "nil")

        guard let access, let refresh, let expiryStr, let expiryTimestamp = TimeInterval(expiryStr) else {
            self.tokens = nil
            return
        }

        self.tokens = Tokens(accessToken: access, refreshToken: refresh, refreshExpiry: Date(timeIntervalSince1970: expiryTimestamp))
    }


    func clearTokens() {
        ["accessToken", "refreshToken", "refreshExpiry"].forEach {
            KeychainHelper.standard.delete(service: "SmartSpend", account: $0)
        }
        self.tokens = nil
    }

    func refreshAccessToken() async throws {
        guard let tokens = tokens else {
            throw URLError(.userAuthenticationRequired)
        }

        struct RefreshResponse: Decodable {
            let access_token: String
        }

        let response: RefreshResponse = try await APIClient.shared.rawRequest(
            endpoint: "api/token/",
            method: "POST",
            headers: [
                "Authorization": "Bearer \(tokens.accessToken)",
                "Refresh-Token": tokens.refreshToken
            ]
        )

        // Save new access token
        saveTokens(access: response.access_token,
                   refresh: tokens.refreshToken,
                   expiry: tokens.refreshExpiry) // keep same refresh expiry
    }

    var accessToken: String? { tokens?.accessToken }
    var refreshToken: String? { tokens?.refreshToken }
    var refreshExpiry: Date? { tokens?.refreshExpiry }
}
