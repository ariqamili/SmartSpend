//
//  TokenManager.swift
//  SmartSpend
//
//  Created by shortcut mac on 21.8.25.
//


import Foundation

/// Manages JWT access tokens and refresh tokens with automatic refresh
final class TokenManager: ObservableObject {
    static let shared = TokenManager()
    
    @Published var isAuthenticated: Bool = false
    
    private let networking: AuthNetworking
    private var refreshTask: Task<Void, Never>?
    
    // Token storage keys
    private enum KeychainKeys {
        static let refreshToken = "refresh_token"
        static let refreshTokenExpiry = "refresh_token_expiry"
        static let accessToken = "access_token"
        static let accessTokenExpiry = "access_token_expiry"
    }
    
    init(networking: AuthNetworking = RemoteAuthNetworking()) {
        self.networking = networking
        checkAuthenticationStatus()
        startTokenRefreshTimer()
    }
    
    /// Check if user has valid tokens on app launch
    private func checkAuthenticationStatus() {
        guard KeychainHelper.standard.read(for: KeychainKeys.refreshToken) != nil else {
            isAuthenticated = false
            return
        }
        
        // Check if refresh token is expired
        if let expiryString = KeychainHelper.standard.read(for: KeychainKeys.refreshTokenExpiry),
           let expiryDate = ISO8601DateFormatter().date(from: expiryString),
           expiryDate < Date() {
            // Refresh token expired, clear everything
            clearAllTokens()
            isAuthenticated = false
            return
        }
        
        isAuthenticated = true
    }
    
    /// Get valid access token (automatically refreshes if needed)
    func getValidAccessToken() async throws -> String? {
        // Check if access token exists and is not expired
        if let accessToken = KeychainHelper.standard.read(for: KeychainKeys.accessToken),
           let expiryString = KeychainHelper.standard.read(for: KeychainKeys.accessTokenExpiry),
           let expiryDate = ISO8601DateFormatter().date(from: expiryString),
           expiryDate > Date().addingTimeInterval(300) { // Refresh 5 minutes before expiry
            return accessToken
        }
        
        // Need to refresh access token
        return try await refreshAccessToken()
    }
    
    /// Refresh access token using refresh token
    private func refreshAccessToken() async throws -> String? {
        guard KeychainHelper.standard.read(for: KeychainKeys.refreshToken) != nil else {
            await MainActor.run {
                isAuthenticated = false
            }
            throw NetworkError.noRefreshToken
        }
        
        do {
            // This should be implemented in your networking layer
            if let remoteNetworking = networking as? RemoteAuthNetworking {
                return try await remoteNetworking.refreshAccessToken()
            } else {
                // Mock implementation
                return try await networking.refreshAccessToken()
            }
        } catch {
            // If refresh fails, user needs to sign in again
            await MainActor.run {
                clearAllTokens()
                isAuthenticated = false
            }
            throw error
        }
    }
    
    /// Start automatic token refresh timer
    private func startTokenRefreshTimer() {
        refreshTask?.cancel()
        refreshTask = Task {
            while !Task.isCancelled {
                // Check every 5 minutes if token needs refresh
                try? await Task.sleep(nanoseconds: 300_000_000_000) // 5 minutes
                
                if isAuthenticated {
                    do {
                        _ = try await getValidAccessToken()
                    } catch {
                        // If refresh fails, user will be logged out
                        print("Token refresh failed: \(error)")
                    }
                }
            }
        }
    }
    
    /// Clear all stored tokens
    func clearAllTokens() {
        KeychainHelper.standard.delete(for: KeychainKeys.refreshToken)
        KeychainHelper.standard.delete(for: KeychainKeys.refreshTokenExpiry)
        KeychainHelper.standard.delete(for: KeychainKeys.accessToken)
        KeychainHelper.standard.delete(for: KeychainKeys.accessTokenExpiry)
    }
    
    /// Sign out user
    func signOut() {
        refreshTask?.cancel()
        clearAllTokens()
        isAuthenticated = false
    }
    
    deinit {
        refreshTask?.cancel()
    }
}
