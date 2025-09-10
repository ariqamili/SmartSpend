////
////  TokenManager.swift
////  SmartSpend
////
////  Created by Refik Jaija on 20.8.25.
////
//// Network/TokenManager.swift
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
//  TokenManager.swift
//  SmartSpend
//
//  Created by Refik Jaija on 20.8.25.
//
// Network/TokenManager.swift
import Foundation
import Security

actor TokenManager {
    static let shared = TokenManager()

    private(set) var accessToken: String?
    private(set) var refreshToken: String?
    private(set) var refreshTokenExpiryDate: String?

    // UPDATED: Save all tokens including expiry date
    func saveTokens(access: String, refresh: String, refreshExpiryDate: String? = nil) {
        self.accessToken = access
        self.refreshToken = refresh
        self.refreshTokenExpiryDate = refreshExpiryDate
        
        // Save refresh token and expiry date to keychain
        KeychainHelper.standard.save(refresh, service: "SmartSpend", account: "refreshToken")
        if let expiryDate = refreshExpiryDate {
            KeychainHelper.standard.save(expiryDate, service: "SmartSpend", account: "refreshTokenExpiryDate")
        }
    }

    func loadTokens() {
        if let refresh = KeychainHelper.standard.read(service: "SmartSpend", account: "refreshToken") {
            self.refreshToken = refresh
        }
        if let expiryDate = KeychainHelper.standard.read(service: "SmartSpend", account: "refreshTokenExpiryDate") {
            self.refreshTokenExpiryDate = expiryDate
        }
    }

    // NEW: Check if refresh token is expired
    func isRefreshTokenExpired() -> Bool {
        guard let expiryDateString = refreshTokenExpiryDate,
              let expiryDate = ISO8601DateFormatter().date(from: expiryDateString) else {
            return false // If no expiry date, assume it's not expired
        }
        
        return Date() > expiryDate
    }

    // UPDATED: Use the endpoint from your auth flow document
    func refreshAccessToken() async throws {
        guard let refresh = refreshToken else {
            throw URLError(.userAuthenticationRequired)
        }
        
        // Check if refresh token is expired
        if isRefreshTokenExpired() {
            // Clear tokens and force logout
            await clearTokens()
            throw RefreshTokenError.refreshTokenExpired
        }

        
        let url = URL(string: "https://7906c6ac2a58.ngrok-free.app/api/token")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(refresh, forHTTPHeaderField: "Refresh-Token")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        if httpResponse.statusCode == 401 {
            // Refresh token expired, clear tokens
            await clearTokens()
            throw RefreshTokenError.refreshTokenExpired
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NSError(domain: "", code: httpResponse.statusCode, userInfo: nil)
        }
        
        struct RefreshResponse: Decodable {
            let access_token: String
        }
        
        let refreshResponse = try JSONDecoder().decode(RefreshResponse.self, from: data)
        self.accessToken = refreshResponse.access_token
    }
    
    // NEW: Clear all tokens
    func clearTokens() {
        self.accessToken = nil
        self.refreshToken = nil
        self.refreshTokenExpiryDate = nil
        
        // Remove from keychain
        KeychainHelper.standard.delete(service: "SmartSpend", account: "refreshToken")
        KeychainHelper.standard.delete(service: "SmartSpend", account: "refreshTokenExpiryDate")
    }
}

// NEW: Custom error for refresh token issues
enum RefreshTokenError: Error {
    case refreshTokenExpired
}
