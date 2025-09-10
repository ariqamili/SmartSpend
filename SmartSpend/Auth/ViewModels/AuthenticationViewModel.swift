//
//  AuthenticationViewModel.swift
//  SmartSpend
//
//  Created by Refik Jaija on 17.8.25.
//

//import Foundation
//import SwiftUI
//import GoogleSignIn
//
//@MainActor
//class AuthenticationViewModel: ObservableObject {
//    @Published var isSignedIn = false
//    @Published var isRestoringSession = true
//    @Published var fullName: String?
//    @Published var email: String?
//    @Published var profileImageURL: String?
//    
//    
//    func signIn() {
//        print("DEBUG: signIn() called")
//
//        guard let rootVC = UIApplication.shared.connectedScenes
//            .compactMap({ $0 as? UIWindowScene })
//            .first?.windows.first?.rootViewController else { return }
//
//        GIDSignIn.sharedInstance.signIn(withPresenting: rootVC) { [weak self] result, error in
//            if let error = error {
//                print("Sign in error:", error)
//                return
//            }
//            if let user = result?.user {
//                self?.setSignedIn(user: user)
//            }
//        }
//    }
//
//
//    private func setSignedIn(user: GIDGoogleUser) {
//        fullName = user.profile?.name
//        email = user.profile?.email
//
//        // Get ID Token and Access Token
//        let idToken = user.idToken?.tokenString
//        let accessToken = user.accessToken.tokenString
//
//        print("Got ID Token:", idToken ?? "nil")
//        print("Got Access Token:", accessToken)
//
//        Task {
//            do {
//                struct SignInResponse: Decodable {
//                    let message: String
//                    let access_token: String
//                    let refresh_token: String
//                    let user: User?
//                    let user_data: User?
//
//                }
//
//                // send the idToken
//                let response: SignInResponse = try await APIClient.shared.request(
//                    endpoint: "api/auth/google",
//                    method: "POST",
//                    body: ["id_token": idToken ?? ""]
//                )
//                
//                //  Detailed logging
//                print("   Backend response received")
//                print("   Response:", response)
//                print("   Message:", response.message)
//                print("   Access Token:", response.access_token)
//                print("   Refresh Token:", response.refresh_token)
//
//                await TokenManager.shared.saveTokens(
//                    access: response.access_token,
//                    refresh: response.refresh_token
//                )
//                
//                
//                DispatchQueue.main.async {
//                    self.isSignedIn = true
//                    print("User marked as signed in")
//                }
//            } catch {
//                print("Sign in failed with error:", error)
//            }
//        }
//    }
//
//
//
//    func signOut() {
//        Task {
//            _ = try? await APIClient.shared.request(
//                endpoint: "api/auth/logout",
//                method: "POST"
//            ) as [String: String]
//
//            await TokenManager.shared.saveTokens(access: "", refresh: "")
//            self.isSignedIn = false
//        }
//    }
//}
//





//
//import Foundation
//import SwiftUI
//import GoogleSignIn
//
//@MainActor
//class AuthenticationViewModel: ObservableObject {
//    @Published var isSignedIn = false
//    @Published var isRestoringSession = true
//    @Published var fullName: String?
//    @Published var email: String?
//    @Published var profileImageURL: String?
//    
//    // TEST MODE - Set to false when backend is available
//    private let testMode = true
//    
//    func restoreSession() async {
//        isRestoringSession = true
//        defer { isRestoringSession = false }   // always reset at the end
//        
//        if testMode {
//            // TEST MODE: Simulate session restoration
//            try? await Task.sleep(nanoseconds: 1_000_000_000) // 1 second delay to simulate network
//            
//            // Check if we have stored test credentials
//            let testRefreshToken = KeychainHelper.standard.read(service: "SmartSpend", account: "refreshToken")
//            
//            if let refreshToken = testRefreshToken, !refreshToken.isEmpty {
//                print("TEST MODE: Found refresh token, restoring session")
//                self.isSignedIn = true
//                self.fullName = "Test User"
//                self.email = "test@example.com"
//                print("TEST MODE: Session restored successfully")
//            } else {
//                print("TEST MODE: No refresh token found, user is logged out")
//                self.isSignedIn = false
//            }
//            return
//        }
//        
//        // PRODUCTION MODE - Uncomment when backend is available
//        /*
//        // Load tokens from keychain
//        await TokenManager.shared.loadTokens()
//        
//        // Check if we have a refresh token
//        guard let refreshToken = await TokenManager.shared.getRefreshToken(), !refreshToken.isEmpty else {
//            print("No refresh token found, user is logged out")
//            self.isSignedIn = false
//            return
//        }
//        
//        do {
//            // Try to refresh the access token
//            try await TokenManager.shared.refreshAccessToken()
//            
//            // Validate the session by making a test API call
//            // This ensures the tokens are actually valid and the user session exists
//            let _: [String: Any] = try await APIClient.shared.request(
//                endpoint: "api/auth/validate", // or whatever endpoint validates the session
//                method: "GET"
//            )
//            
//            self.isSignedIn = true
//            print("Session restored successfully - tokens refreshed and validated")
//        } catch {
//            print("Failed to restore session:", error)
//            // Clear invalid tokens
//            await TokenManager.shared.clearTokens()
//            self.isSignedIn = false
//        }
//        */
//    }
//    
//    func signIn() {
//        print("DEBUG: signIn() called")
//        
//        if testMode {
//            // TEST MODE: Simulate sign in
//            Task {
//                try? await Task.sleep(nanoseconds: 500_000_000) // 0.5 second delay
//                
//                // Save test tokens
//                KeychainHelper.standard.save("test_access_token_123", service: "SmartSpend", account: "access_token")
//                KeychainHelper.standard.save("test_refresh_token_456", service: "SmartSpend", account: "refresh_token")
//                
//                await MainActor.run {
//                    self.isSignedIn = true
//                    self.fullName = "Test User"
//                    self.email = "test@example.com"
//                    print("TEST MODE: User signed in successfully")
//                }
//            }
//            return
//        }
//        
//        // PRODUCTION MODE - Uncomment when backend is available
//        /*
//        guard let rootVC = UIApplication.shared.connectedScenes
//            .compactMap({ $0 as? UIWindowScene })
//            .first?.windows.first?.rootViewController else { return }
//        
//        GIDSignIn.sharedInstance.signIn(withPresenting: rootVC) { [weak self] result, error in
//            if let error = error {
//                print("Sign in error:", error)
//                return
//            }
//            if let user = result?.user {
//                self?.setSignedIn(user: user)
//            }
//        }
//        */
//    }
//    
//    private func setSignedIn(user: GIDGoogleUser) {
//        // PRODUCTION MODE - Uncomment when backend is available
//        /*
//        fullName = user.profile?.name
//        email = user.profile?.email
//        
//        // Get ID Token and Access Token
//        let idToken = user.idToken?.tokenString
//        let accessToken = user.accessToken.tokenString
//        
//        print("Got ID Token:", idToken ?? "nil")
//        print("Got Access Token:", accessToken)
//        
//        Task {
//            do {
//                struct SignInResponse: Decodable {
//                    let message: String
//                    let access_token: String
//                    let refresh_token: String
//                    let user: User?
//                    let user_data: User?
//                }
//                
//                // send the idToken
//                let response: SignInResponse = try await APIClient.shared.request(
//                    endpoint: "api/auth/google",
//                    method: "POST",
//                    body: ["id_token": idToken ?? ""]
//                )
//                
//                // Detailed logging
//                print("Backend response received")
//                print("Response:", response)
//                print("Message:", response.message)
//                print("Access Token:", response.access_token)
//                print("Refresh Token:", response.refresh_token)
//                
//                await TokenManager.shared.saveTokens(
//                    access: response.access_token,
//                    refresh: response.refresh_token
//                )
//                
//                DispatchQueue.main.async {
//                    self.isSignedIn = true
//                    print("User marked as signed in")
//                }
//            } catch {
//                print("Sign in failed with error:", error)
//            }
//        }
//        */
//    }
//    
//    func signOut() {
//        Task {
//            if testMode {
//                // TEST MODE: Clear test tokens
//                KeychainHelper.standard.delete(service: "SmartSpend", account: "access_token")
//                KeychainHelper.standard.delete(service: "SmartSpend", account: "refresh_token")
//                
//                await MainActor.run {
//                    self.isSignedIn = false
//                    self.fullName = nil
//                    self.email = nil
//                    self.profileImageURL = nil
//                    print("TEST MODE: User signed out successfully")
//                }
//                return
//            }
//            
//            // PRODUCTION MODE - Uncomment when backend is available
//            /*
//            do {
//                // Notify backend of logout
//                let _: [String: String] = try await APIClient.shared.request(
//                    endpoint: "api/auth/logout",
//                    method: "POST"
//                )
//            } catch {
//                print("Logout API call failed:", error)
//                // Continue with local logout even if API call fails
//            }
//            
//            // Clear tokens locally
//            await TokenManager.shared.clearTokens()
//            
//            // Update UI
//            DispatchQueue.main.async {
//                self.isSignedIn = false
//                self.fullName = nil
//                self.email = nil
//                self.profileImageURL = nil
//            }
//            */
//        }
//    }
//}








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
                self?.setSignedIn(user: user, userVM: userVM)
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

        guard let expiry = await TokenManager.shared.refreshExpiry, expiry > Date() else {
            await TokenManager.shared.clearTokens()
            isSignedIn = false
            return
        }

        await userVM.fetchUser()
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
