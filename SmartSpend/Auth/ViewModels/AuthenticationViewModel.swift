////
////  AuthenticationViewModel.swift
////  SmartSpend
////
////  Created by Refik Jaija on 17.8.25.
////
//
//import Foundation
//import SwiftUI
//import GoogleSignIn
//
//@MainActor
//class AuthenticationViewModel: ObservableObject {
//    @Published var isSignedIn = false {
//        didSet {
//            print("debug22: signed in val: \(isSignedIn)")
//        }
//    }
//    @Published var isRestoringSession = true
//    @Published var fullName: String?
//    @Published var email: String?
//    @Published var profileImageURL: String?
//    
//    // MARK: - Google Sign In
//    func signIn(userVM: UserViewModel) {
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
//                self?.setSignedIn(user: user, userVM: userVM)
//            }
//        }
//    }
//
//    private func setSignedIn(user: GIDGoogleUser, userVM: UserViewModel) {
//        fullName = user.profile?.name
//        email = user.profile?.email
//        profileImageURL = user.profile?.imageURL(withDimension: 200)?.absoluteString
//
//        let idToken = user.idToken?.tokenString
//        print("Got ID Token:", idToken ?? "nil")
//
//        Task {
//            do {
//                struct SignInResponse: Decodable {
//                    let message: String
//                    let access_token: String
//                    let refresh_token: String
//                    let refresh_token_expiry_date: String
//                    let data: User
//                }
//
//                // Call backend with Google ID token
//                let response: SignInResponse = try await APIClient.shared.request(
//                    endpoint: "api/auth/google",
//                    method: "POST",
//                    body: ["id_token": idToken ?? ""]
//                )
//
//                print("Backend sign-in response:", response)
//
//                // Parse expiry date
//                let expiryDate = ISO8601DateFormatter().date(from: response.refresh_token_expiry_date) ?? Date().addingTimeInterval(60 * 60 * 24)
//
//                // Save tokens securely
//                await TokenManager.shared.saveTokens(
//                    access: response.access_token,
//                    refresh: response.refresh_token,
//                    expiry: expiryDate
//                )
//
//                // Set user instantly from login response
//                userVM.currentUser = response.data
//
//                self.isSignedIn = true
//            } catch {
//                print(" Sign in failed:", error)
//            }
//        }
//    }
//
//    // MARK: - Session Restore
//    func restoreSession(userVM: UserViewModel) async {
//        await TokenManager.shared.loadTokens()
//        defer { isRestoringSession = false }
//
//        guard let expiry = await TokenManager.shared.refreshExpiry, expiry > Date() else {
//            await TokenManager.shared.clearTokens()
//            isSignedIn = false
//            return
//        }
//
//        await userVM.fetchUser()
//        do {
//            try await TokenManager.shared.refreshAccessToken()
//             await userVM.fetchUser()
//            isSignedIn = true
//        } catch {
//            print("Failed to restore session:", error)
//            await TokenManager.shared.clearTokens()
//            isSignedIn = false
//        }
//    }
//
//    // MARK: - Sign Out
//    func signOut() {
//        Task {
//            _ = try? await APIClient.shared.request(
//                endpoint: "api/auth/logout",
//                method: "POST"
//            ) as [String: String]
//
//            await TokenManager.shared.clearTokens()
//            isSignedIn = false
//        }
//    }
//}


import Foundation
import SwiftUI
import GoogleSignIn
import AuthenticationServices

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
    
    @Published var isLoading = false
    @Published var showAlert = false
    @Published var alertMessage = ""
    @Published var isSuccess = false
    
    //MARK: Google Sign In
    func signIn(userVM: UserViewModel) {
        print("DEBUG: Google signIn() called")
        isLoading = true

        guard let rootVC = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first?.windows.first?.rootViewController else {
            showError("Unable to get root view controller")
            return
        }

        GIDSignIn.sharedInstance.signIn(withPresenting: rootVC) { [weak self] result, error in
            if let error = error {
                print("Google sign in error:", error)
                self?.showError("Google Sign-In failed: \(error.localizedDescription)")
                return
            }
            if let user = result?.user {
                self?.setGoogleSignedIn(user: user, userVM: userVM)
            }
        }
    }

    private func setGoogleSignedIn(user: GIDGoogleUser, userVM: UserViewModel) {
        fullName = user.profile?.name
        email = user.profile?.email
        profileImageURL = user.profile?.imageURL(withDimension: 200)?.absoluteString

        let idToken = user.idToken?.tokenString
        print("Got ID Token:", idToken ?? "nil")

        Task {
            do {
                struct GoogleSignInResponse: Decodable {
                    let message: String
                    let access_token: String
                    let refresh_token: String
                    let refresh_token_expiry_date: String
                    let data: User
                }

                let response: GoogleSignInResponse = try await APIClient.shared.request(
                    endpoint: "api/auth/google",
                    method: "POST",
                    body: ["id_token": idToken ?? ""]
                )

                print("Backend Google sign-in response:", response)

                let expiryDate = ISO8601DateFormatter().date(from: response.refresh_token_expiry_date) ?? Date().addingTimeInterval(60 * 60 * 24)

                await TokenManager.shared.saveTokens(
                    access: response.access_token,
                    refresh: response.refresh_token,
                    expiry: expiryDate
                )

                userVM.currentUser = response.data

                self.isSignedIn = true
                self.showSuccess(response.message)
            } catch {
                print("Google sign in failed:", error)
                self.showError("Sign-in failed: \(error.localizedDescription)")
            }
        }
    }

    //MARK: Apple Sign In
    func handleAppleSignIn(with authorization: ASAuthorization, userVM: UserViewModel) {
        guard let userCredential = authorization.credential as? ASAuthorizationAppleIDCredential else {
            showError("Invalid Apple credentials received")
            return
        }
        
        print("Apple User ID: \(userCredential.user)")
        
        isLoading = true
        
        let userId = userCredential.user
        let firstName = userCredential.fullName?.givenName ?? ""
        let lastName = userCredential.fullName?.familyName ?? ""
        let email = userCredential.email ?? ""
        
        let requestData = AppleUserRequest(
            userId: userId,
            firstName: firstName,
            lastName: lastName,
            email: email
        )
        
        sendAppleSignInRequest(requestData, userVM: userVM)
    }
    
    private func sendAppleSignInRequest(_ userData: AppleUserRequest, userVM: UserViewModel) {
        Task {
            do {
                let response: AppleSignInResponse = try await APIClient.shared.request(
                    endpoint: "api/auth/apple",
                    method: "POST",
                    body: userData
                )
                
                print("Backend Apple sign-in response:", response)
                
                let expiryDate = ISO8601DateFormatter().date(from: response.refreshTokenExpiryDate) ?? Date().addingTimeInterval(60 * 60 * 24 * 30)
                
                await TokenManager.shared.saveTokens(
                    access: response.accessToken,
                    refresh: response.refreshToken,
                    expiry: expiryDate
                )
                
                userVM.currentUser = response.userData
                
                self.isSignedIn = true
                self.showSuccess(response.message)
                
            } catch {
                print("Apple sign-in network error:", error)
                self.showError("Apple Sign-In failed: \(error.localizedDescription)")
            }
        }
    }
    
    func handleAppleSignInError(with error: Error) {
        showError("Apple Sign-In failed: \(error.localizedDescription)")
    }

    // MARK: Session Restore
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

    // MARK: Sign Out
    func signOut() {
        isLoading = true
        Task {
            _ = try? await APIClient.shared.request(
                endpoint: "api/auth/logout",
                method: "POST"
            ) as [String: String]

            await TokenManager.shared.clearTokens()
            
            await MainActor.run {
                self.isSignedIn = false
                self.isLoading = false
                self.fullName = nil
                self.email = nil
                self.profileImageURL = nil
            }
        }
    }

    private func showError(_ message: String) {
        isLoading = false
        alertMessage = message
        isSuccess = false
        showAlert = true
    }
    
    private func showSuccess(_ message: String) {
        isLoading = false
        alertMessage = message
        isSuccess = true
        showAlert = true
    }
}

// MARK: Apple Sign-In Data Models
struct AppleUserRequest: Codable {
    let userId: String
    let firstName: String
    let lastName: String
    let email: String
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case firstName = "first_name"
        case lastName = "last_name"
        case email
    }
}

struct AppleSignInResponse: Codable {
    let message: String
    let refreshToken: String
    let refreshTokenExpiryDate: String
    let accessToken: String
    let userData: User
    
    enum CodingKeys: String, CodingKey {
        case message
        case refreshToken = "refresh_token"
        case refreshTokenExpiryDate = "refresh_token_expiry_date"
        case accessToken = "access_token"
        case userData = "user_data"
    }
}
