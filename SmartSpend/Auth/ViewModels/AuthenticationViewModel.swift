//
//  AuthenticationViewModel.swift
//  SmartSpend
//
//  Created by Refik Jaija on 17.8.25.
//
import Foundation
import SwiftUI
import GoogleSignIn

@MainActor
class AuthenticationViewModel: ObservableObject {
    @Published var isSignedIn = false {
        didSet {
            print("debug22: signed in val: \(isSignedIn)")
        }
    }
    @Published var isRestoringSession = true
    @Published var fullName: String?
    @Published var email: String?
    @Published var profileImageURL: String?
    
    // MARK: - Google Sign In
    func signIn(userVM: UserViewModel) {
        print("DEBUG: signIn() called")

        guard let rootVC = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first?.windows.first?.rootViewController else { return }

        GIDSignIn.sharedInstance.signIn(withPresenting: rootVC) { [weak self] result, error in
            if let error = error {
                print("Sign in error:", error)
                return
            }
            if let user = result?.user {
                Task { @MainActor [weak self] in
                    self?.setSignedIn(user: user, userVM: userVM)
                }
            }
        }
    }

    private func setSignedIn(user: GIDGoogleUser, userVM: UserViewModel) {
        fullName = user.profile?.name
        email = user.profile?.email
        profileImageURL = user.profile?.imageURL(withDimension: 200)?.absoluteString

        let idToken = user.idToken?.tokenString
        print("Got ID Token:", idToken ?? "nil")

        Task {
            do {
                struct SignInResponse: Decodable {
                    let message: String
                    let access_token: String
                    let refresh_token: String
                    let refresh_token_expiry_date: String
                    let data: User
                }

                // Call backend with Google ID token
                let response: SignInResponse = try await APIClient.shared.request(
                    endpoint: "api/auth/google",
                    method: "POST",
                    body: ["id_token": idToken ?? ""]
                )

                print("Backend sign-in response:", response)

                // Parse expiry date
                let expiryDate = ISO8601DateFormatter().date(from: response.refresh_token_expiry_date) ?? Date().addingTimeInterval(60 * 60 * 24)

                // Save tokens securely
                await TokenManager.shared.saveTokens(
                    access: response.access_token,
                    refresh: response.refresh_token,
                    expiry: expiryDate
                )

                // Set user instantly from login response
                userVM.currentUser = response.data

                self.isSignedIn = true
            } catch {
                print(" Sign in failed:", error)
            }
        }
    }

    // MARK: - Session Restore
    func restoreSession(userVM: UserViewModel) async {
        await TokenManager.shared.loadTokens()
        defer { isRestoringSession = false }
        
        
        print("debug: expiry = \(String(describing: await TokenManager.shared.refreshExpiry))")
        guard let expiry = await TokenManager.shared.refreshExpiry, expiry > Date() else {
            await TokenManager.shared.clearTokens()
            isSignedIn = false
            return
        }

        
        do {
            try await TokenManager.shared.refreshAccessToken()
             await userVM.fetchUser()
            isSignedIn = true
        } catch {
            print("Failed to restore session:", error)
            await TokenManager.shared.clearTokens()
            isSignedIn = false
        }
    }

    // MARK: - Sign Out
    func signOut() {
        Task {
            _ = try? await APIClient.shared.request(
                endpoint: "api/auth/logout",
                method: "POST"
            ) as [String: String]

            await TokenManager.shared.clearTokens()
            isSignedIn = false
        }
    }
}
