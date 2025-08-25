import Foundation

/// The JSON response your backend should return for a successful /auth/social call.
/// Updated to match your auth flow requirements
/// Example response:
/// {
///   "access_token": "<jwt>",
///   "access_token_expires_in": 1800,
///   "refresh_token": "<opaque-refresh-token>",
///   "refresh_token_expires_in": 2592000,
///   "token_type": "Bearer",
///   "user": { "id":"...", "email":"...", "name":"..." }
/// }
private struct BackendAuthResponse: Decodable {
    let access_token: String?
    let access_token_expires_in: Int?
    let refresh_token: String?
    let refresh_token_expires_in: Int?
    let token_type: String?
    let user: UserInfo?
    
    struct UserInfo: Decodable {
        let id: String?
        let email: String?
        let name: String?
        let first_name: String?
        let last_name: String?
    }
}

/// Response structure for refresh token endpoint
private struct BackendRefreshTokenResponse: Decodable {
    let access_token: String
    let access_token_expires_in: Int?
    let refresh_token: String?
    let refresh_token_expires_in: Int?
    let token_type: String?
}

public final class RemoteAuthNetworking: AuthNetworking {
    private let baseURL: URL

    // NOTE: changed default argument to an optional to avoid visibility mismatch
    // between the public initializer and internal AuthConstants.static properties.
    public init(baseURL: URL? = nil) {
        self.baseURL = baseURL ?? AuthConstants.backendBaseURL
    }

    public func sendProviderToken(_ token: ProviderToken) async throws -> String? {
        let url = baseURL.appendingPathComponent(AuthConstants.authEndpointPath)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // Build payload focused on id_token as per your flow
        var payload: [String: Any] = [
            "provider": token.provider
        ]
        
        // Priority: id_token (required for your flow)
        if let idToken = token.idToken {
            payload["id_token"] = idToken
        }
        
        // Include authorization code as fallback if available
        if let authCode = token.authorizationCode {
            payload["authorization_code"] = authCode
        }
        
        // Include nonce for Apple verification
        if let nonce = token.rawNonce {
            payload["raw_nonce"] = nonce
        }
        
        // Include user ID for reference
        if let userID = token.userID {
            payload["user_id"] = userID
        }

        request.httpBody = try JSONSerialization.data(withJSONObject: payload, options: [])

        let (data, resp) = try await URLSession.shared.data(for: request)
        guard let http = resp as? HTTPURLResponse else {
            throw NetworkError.noHTTPResponse
        }

        guard (200...299).contains(http.statusCode) else {
            let body = String(data: data, encoding: .utf8) ?? "no body"
            throw NetworkError.serverError(statusCode: http.statusCode, message: body)
        }

        let decoder = JSONDecoder()
        let backendResponse = try decoder.decode(BackendAuthResponse.self, from: data)

        // Store tokens in Keychain with expiration handling
        if let refreshToken = backendResponse.refresh_token {
            KeychainHelper.standard.save(token: refreshToken, for: "refresh_token")
            
            // Store refresh token expiration if provided
            if let expiresIn = backendResponse.refresh_token_expires_in {
                let expirationDate = Date().addingTimeInterval(TimeInterval(expiresIn))
                let expirationString = ISO8601DateFormatter().string(from: expirationDate)
                KeychainHelper.standard.save(token: expirationString, for: "refresh_token_expiry")
            }
        }
        
        if let accessToken = backendResponse.access_token {
            KeychainHelper.standard.save(token: accessToken, for: "access_token")
            
            // Store access token expiration (default 30 minutes as per your flow)
            let expiresIn = backendResponse.access_token_expires_in ?? 1800 // 30 minutes default
            let expirationDate = Date().addingTimeInterval(TimeInterval(expiresIn))
            let expirationString = ISO8601DateFormatter().string(from: expirationDate)
            KeychainHelper.standard.save(token: expirationString, for: "access_token_expiry")
        }

        return backendResponse.refresh_token
    }
    
    /// Refresh access token using stored refresh token
    public func refreshAccessToken() async throws -> String? {
        guard let refreshToken = KeychainHelper.standard.read(for: "refresh_token") else {
            throw NetworkError.noRefreshToken
        }
        
        // Check if refresh token is expired
        if let expiryString = KeychainHelper.standard.read(for: "refresh_token_expiry"),
           let expiryDate = ISO8601DateFormatter().date(from: expiryString),
           expiryDate < Date() {
            // Refresh token expired, clear everything
            KeychainHelper.standard.delete(for: "refresh_token")
            KeychainHelper.standard.delete(for: "refresh_token_expiry")
            KeychainHelper.standard.delete(for: "access_token")
            KeychainHelper.standard.delete(for: "access_token_expiry")
            throw NetworkError.refreshTokenExpired
        }
        
        let url = baseURL.appendingPathComponent("/auth/refresh")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let payload = ["refresh_token": refreshToken]
        request.httpBody = try JSONSerialization.data(withJSONObject: payload, options: [])
        
        let (data, resp) = try await URLSession.shared.data(for: request)
        guard let http = resp as? HTTPURLResponse else {
            throw NetworkError.noHTTPResponse
        }
        
        guard (200...299).contains(http.statusCode) else {
            let body = String(data: data, encoding: .utf8) ?? "no body"
            if http.statusCode == 401 {
                // Refresh token invalid, clear everything
                KeychainHelper.standard.delete(for: "refresh_token")
                KeychainHelper.standard.delete(for: "refresh_token_expiry")
                KeychainHelper.standard.delete(for: "access_token")
                KeychainHelper.standard.delete(for: "access_token_expiry")
                throw NetworkError.refreshTokenExpired
            }
            throw NetworkError.serverError(statusCode: http.statusCode, message: body)
        }
        
        let decoder = JSONDecoder()
        let refreshResponse = try decoder.decode(BackendRefreshTokenResponse.self, from: data)
        
        // Store new access token
        KeychainHelper.standard.save(token: refreshResponse.access_token, for: "access_token")
        
        let expiresIn = refreshResponse.access_token_expires_in ?? 1800 // 30 minutes default
        let expirationDate = Date().addingTimeInterval(TimeInterval(expiresIn))
        let expirationString = ISO8601DateFormatter().string(from: expirationDate)
        KeychainHelper.standard.save(token: expirationString, for: "access_token_expiry")
        
        // Store new refresh token if provided
        if let newRefreshToken = refreshResponse.refresh_token {
            KeychainHelper.standard.save(token: newRefreshToken, for: "refresh_token")
            
            if let expiresIn = refreshResponse.refresh_token_expires_in {
                let expirationDate = Date().addingTimeInterval(TimeInterval(expiresIn))
                let expirationString = ISO8601DateFormatter().string(from: expirationDate)
                KeychainHelper.standard.save(token: expirationString, for: "refresh_token_expiry")
            }
        }
        
        return refreshResponse.access_token
    }
    
    // MARK: - Additional required methods for AuthCoordinator
    public func storedRefreshToken() -> String? {
        return KeychainHelper.standard.read(for: "refresh_token")
    }
    
    public func refresh(refreshToken: String) async throws -> String {
        let url = baseURL.appendingPathComponent("/auth/refresh")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let payload = ["refresh_token": refreshToken]
        request.httpBody = try JSONSerialization.data(withJSONObject: payload, options: [])
        
        let (data, resp) = try await URLSession.shared.data(for: request)
        guard let http = resp as? HTTPURLResponse else {
            throw NetworkError.noHTTPResponse
        }
        
        guard (200...299).contains(http.statusCode) else {
            let body = String(data: data, encoding: .utf8) ?? "no body"
            throw NetworkError.serverError(statusCode: http.statusCode, message: body)
        }
        
        let decoder = JSONDecoder()
        let refreshResponse = try decoder.decode(BackendRefreshTokenResponse.self, from: data)
        
        // Store new access token
        KeychainHelper.standard.save(token: refreshResponse.access_token, for: "access_token")
        
        let expiresIn = refreshResponse.access_token_expires_in ?? 1800
        let expirationDate = Date().addingTimeInterval(TimeInterval(expiresIn))
        let expirationString = ISO8601DateFormatter().string(from: expirationDate)
        KeychainHelper.standard.save(token: expirationString, for: "access_token_expiry")
        
        // Store new refresh token if provided
        if let newRefreshToken = refreshResponse.refresh_token {
            KeychainHelper.standard.save(token: newRefreshToken, for: "refresh_token")
        }
        
        return refreshResponse.access_token
    }
    
    public func logout(refreshToken: String) async throws {
        let url = baseURL.appendingPathComponent("/auth/logout")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let payload = ["refresh_token": refreshToken]
        request.httpBody = try JSONSerialization.data(withJSONObject: payload, options: [])
        
        let (_, resp) = try await URLSession.shared.data(for: request)
        guard let http = resp as? HTTPURLResponse else {
            throw NetworkError.noHTTPResponse
        }
        
        // Accept 200-299 status codes for successful logout
        guard (200...299).contains(http.statusCode) else {
            let errorMessage = "Logout failed with status code: \(http.statusCode)"
            throw NetworkError.serverError(statusCode: http.statusCode, message: errorMessage)
        }
    }
}

// MARK: - Network Errors
public enum NetworkError: LocalizedError {
    case noHTTPResponse
    case serverError(statusCode: Int, message: String)
    case noRefreshToken
    case refreshTokenExpired
    
    public var errorDescription: String? {
        switch self {
        case .noHTTPResponse:
            return "Network error: Invalid response"
        case .serverError(let code, let message):
            return "Server error (\(code)): \(message)"
        case .noRefreshToken:
            return "No refresh token found. Please sign in again."
        case .refreshTokenExpired:
            return "Session expired. Please sign in again."
        }
    }
}
