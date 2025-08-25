import Foundation

// MARK: - Protocol Definition
public protocol AuthNetworking {
    // Sends provider token to backend. Returns refresh token or nil.
    func sendProviderToken(_ token: ProviderToken) async throws -> String?
    
    // Refreshes access token using stored refresh token. Returns new access token or nil.
    func refreshAccessToken() async throws -> String?
}

// MARK: - Mock Implementation
public final class MockAuthNetworking: AuthNetworking {
    public init() {}
    
    public func sendProviderToken(_ token: ProviderToken) async throws -> String? {
        // Simulate network latency
        try await Task.sleep(nanoseconds: 600_000_000) // 0.6s
        
        // Simulate successful response with refresh token
        let mockRefreshToken = "mock-refresh-token-\(UUID().uuidString)"
        KeychainHelper.standard.save(token: mockRefreshToken, for: "refresh_token")
        
        return mockRefreshToken
    }
    
    public func refreshAccessToken() async throws -> String? {
        // Simulate network latency
        try await Task.sleep(nanoseconds: 300_000_000) // 0.3s
        
        // Generate new mock access token
        let newAccessToken = "mock-refreshed-access-token-\(UUID().uuidString)"
        KeychainHelper.standard.save(token: newAccessToken, for: "access_token")
        
        return newAccessToken
    }
}
