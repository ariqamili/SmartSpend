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
        
        print("Tokens saved to Keychain")
        let test = KeychainHelper.standard.read(service: "SmartSpend", account: "accessToken")
        print("Immediately after save, read back access:", test ?? "nil")



    }

    func loadTokens() {
        let access = KeychainHelper.standard.read(service: "SmartSpend", account: "accessToken")
        let refresh = KeychainHelper.standard.read(service: "SmartSpend", account: "refreshToken")
        let expiryStr = KeychainHelper.standard.read(service: "SmartSpend", account: "refreshExpiry")

        print("Loaded access:", access ?? "nil")
        print("Loaded refresh:", refresh ?? "nil")
        print("Loaded expiry:", expiryStr ?? "nil")

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
