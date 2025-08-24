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

    func saveTokens(access: String, refresh: String) {
        self.accessToken = access
        self.refreshToken = refresh
        KeychainHelper.standard.save(refresh, service: "SmartSpend", account: "refreshToken")
    }

    func loadTokens() {
        if let refresh = KeychainHelper.standard.read(service: "SmartSpend", account: "refreshToken") {
            self.refreshToken = refresh
        }
    }

    func refreshAccessToken() async throws {
        guard let refresh = refreshToken else { throw URLError(.userAuthenticationRequired) }

        struct RefreshRequest: Encodable {
        let jwt_token: String
        }
        struct RefreshResponse: Decodable {
        let jwt_token: String
         }

        let client = APIClient.shared
        let response: RefreshResponse = try await client.request(
            endpoint: "/auth/refresh-jwt",
            method: "POST",
            body: RefreshRequest(jwt_token: refresh)
        )

        self.accessToken = response.jwt_token
    }
}
