//
//  AuthCoordinator.swift
//  SmartSpend
//
//  Created by shortcut mac on 17.8.25.
//

// Features/Auth/Services/AuthCoordinator.swift
import Foundation
import SwiftUI

/// Centralized auth/session coordinator. Use as an EnvironmentObject at the app root.
@MainActor
final class AuthCoordinator: ObservableObject {
    @Published public private(set) var isAuthenticated: Bool = false
    @Published public private(set) var isRestoring: Bool = false

    private let networking: RemoteAuthNetworking

    init(networking: RemoteAuthNetworking = RemoteAuthNetworking()) {
        self.networking = networking
    }

    /// Called at app start to attempt silent restore using stored refresh token.
    func tryRestoreSession() async {
        isRestoring = true
        defer { isRestoring = false }

        guard let refresh = networking.storedRefreshToken() else {
            isAuthenticated = false
            return
        }

        do {
            _ = try await networking.refresh(refreshToken: refresh)
            isAuthenticated = true
        } catch {
            // On failure clear tokens and require explicit sign-in
            KeychainHelper.standard.delete(for: "refresh_token")
            KeychainHelper.standard.delete(for: "access_token")
            isAuthenticated = false
        }
    }

    /// Called by View when sign-in succeeded.
    func didSignIn() {
        isAuthenticated = true
    }

    /// Sign out locally and attempt server revoke (best-effort).
    func signOut() async {
        if let refresh = networking.storedRefreshToken() {
            do {
                try await networking.logout(refreshToken: refresh)
            } catch {
                // best-effort; still clear local tokens
                print("Failed to notify server about logout: \(error)")
            }
        }

        KeychainHelper.standard.delete(for: "refresh_token")
        KeychainHelper.standard.delete(for: "access_token")
        isAuthenticated = false
    }
}
