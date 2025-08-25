//
//  AppleAuthViewModel.swift
//  SmartSpend
//
//  Created by shortcut mac on 21.8.25.
//


//
//  AppleAuthViewModel.swift
//  SmartSpend
//
//  Created by shortcut mac on 21.8.25.
//


import Foundation
import SwiftUI

@MainActor
final class AppleAuthViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var isAuthenticated: Bool = false

    @AppStorage("email") private(set) var email: String = ""
    @AppStorage("firstName") private(set) var firstName: String = ""
    @AppStorage("lastName") private(set) var lastName: String = ""
    @AppStorage("userID") private(set) var userID: String = ""

    private let authService = AppleAuthService()
    private let network: AuthNetworking

    // Use RemoteAuthNetworking by default (talks to the real backend)
    init(networking: AuthNetworking = RemoteAuthNetworking()) {
        self.network = networking
        checkAuthenticationStatus()
    }

    /// Check if user is already authenticated on app launch
    private func checkAuthenticationStatus() {
        if KeychainHelper.standard.read(for: "refresh_token") != nil && !userID.isEmpty {
            isAuthenticated = true
        }
    }

    /// Start the Apple Sign In flow
    func signIn() {
        Task {
            isLoading = true
            errorMessage = nil
            
            do {
                let providerToken = try await authService.signIn()
                
                // Ensure we have the required ID token
                guard providerToken.idToken != nil else {
                    throw AuthError.missingIdToken
                }

                // Send provider token to backend
                let refreshToken = try await network.sendProviderToken(providerToken)

                // Check if backend returned a valid refresh token
                guard let refreshToken = refreshToken, !refreshToken.isEmpty else {
                    throw AuthError.noRefreshTokenFromBackend
                }

                // Store user information (Apple provides email/name only on first sign-in)
                if let uid = providerToken.userID { userID = uid }
                if let e = providerToken.email, !e.isEmpty { email = e }
                if let g = providerToken.givenName, !g.isEmpty { firstName = g }
                if let f = providerToken.familyName, !f.isEmpty { lastName = f }

                isAuthenticated = true
                
            } catch {
                errorMessage = error.localizedDescription
                isAuthenticated = false
            }
            
            isLoading = false
        }
    }

    /// Sign out the user
    func signOut() {
        // Clear keychain tokens
        KeychainHelper.standard.delete(for: "refresh_token")
        KeychainHelper.standard.delete(for: "access_token")
        
        // Clear user data
        email = ""
        firstName = ""
        lastName = ""
        userID = ""
        
        isAuthenticated = false
        errorMessage = nil
    }

    /// Refresh the access token using stored refresh token
    func refreshAccessToken() async throws -> Bool {
        guard KeychainHelper.standard.read(for: "refresh_token") != nil else {
            throw AuthError.noRefreshToken
        }

        // TODO: Implement refresh token endpoint call
        // This should call your backend's refresh endpoint
        // For now, we'll just check if the refresh token exists
        return true
    }
}
