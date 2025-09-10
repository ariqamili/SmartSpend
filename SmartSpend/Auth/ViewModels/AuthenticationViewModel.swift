////
////  AuthenticationViewModel.swift
////  SmartSpend
////
////  Created by Refik Jaija on 17.8.25.
////
////
//import Foundation
//import SwiftUI
//import GoogleSignIn
//
//@MainActor
//class AuthenticationViewModel: ObservableObject {
//    @Published var isSignedIn = false
//    @Published var fullName: String?
//    @Published var email: String?
//    @Published var profileImageURL: String?
//    @EnvironmentObject var userVM: UserViewModel
//    @EnvironmentObject var categoryVM: CategoryViewModel
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
//                print("   Message:", response.message)
//                print("   Access Token:", response.access_token)
//                print("   Refresh Token:", response.refresh_token)
//
//                await TokenManager.shared.saveTokens(
//                    access: response.access_token,
//                    refresh: response.refresh_token
//                )
//
//    //            await userVM.fetchUser()
//    //            await categoryVM.fetchCategories()
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
//                endpoint: "/auth/logout",
//                method: "POST"
//            ) as [String: String]
//
//            await TokenManager.shared.saveTokens(access: "", refresh: "")
//            self.isSignedIn = false
//        }
//    }
//}




////
////  AuthenticationViewModel.swift
////  SmartSpend
////
////  Created by Refik Jaija on 17.8.25.
////
////
//import Foundation
//import SwiftUI
//import GoogleSignIn
//import AuthenticationServices
//
//@MainActor
//class AuthenticationViewModel: NSObject, ObservableObject {
//    @Published var isSignedIn = false
//    @Published var fullName: String?
//    @Published var email: String?
//    @Published var profileImageURL: String?
//    @EnvironmentObject var userVM: UserViewModel
//    @EnvironmentObject var categoryVM: CategoryViewModel
//    
//    // MARK: - Google Sign In (existing code - unchanged)
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
//            await signInWithBackend(idToken: idToken ?? "", provider: "google")
//        }
//    }
//
//    // MARK: - Apple Sign In (NEW)
//    func signInWithApple() {
//        let request = ASAuthorizationAppleIDProvider().createRequest()
//        request.requestedScopes = [.fullName, .email]
//        
//        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
//        authorizationController.delegate = self
//        authorizationController.presentationContextProvider = self
//        authorizationController.performRequests()
//    }
//
//    // MARK: - Common Backend Sign In (UPDATED)
//    private func signInWithBackend(idToken: String, provider: String) async {
//        do {
//            struct SignInResponse: Decodable {
//                let message: String
//                let access_token: String
//                let refresh_token: String
//                let refresh_token_expiry_date: String?
//                let user_data: UserData?
//            }
//            
//            struct UserData: Decodable {
//                let id: String
//                let email: String
//                let firstName: String?
//                let lastName: String?
//            }
//
//            // Send the idToken to the backend
//            let response: SignInResponse = try await APIClient.shared.request(
//                endpoint: "api/auth/\(provider)",
//                method: "POST",
//                body: ["id_token": idToken]
//            )
//            
//            // Detailed logging
//            print("Backend response received")
//            print("Message:", response.message)
//            print("Access Token:", response.access_token)
//            print("Refresh Token:", response.refresh_token)
//
//            // UPDATED: Save tokens with expiry date
//            await TokenManager.shared.saveTokens(
//                access: response.access_token,
//                refresh: response.refresh_token,
//                refreshExpiryDate: response.refresh_token_expiry_date
//            )
//            
//            // Update user data if available
//            if let userData = response.user_data {
//                self.fullName = "\(userData.firstName ?? "") \(userData.lastName ?? "")".trimmingCharacters(in: .whitespaces)
//                if self.fullName?.isEmpty == true {
//                    self.fullName = nil
//                }
//                self.email = userData.email
//            }
//
//            // Uncomment these when ready
//            // await userVM.fetchUser()
//            // await categoryVM.fetchCategories()
//            
//            DispatchQueue.main.async {
//                self.isSignedIn = true
//                print("User marked as signed in via \(provider)")
//            }
//        } catch {
//            print("Sign in failed with error:", error)
//        }
//    }
//
//    func signOut() {
//        Task {
//            _ = try? await APIClient.shared.request(
//                endpoint: "/auth/logout",
//                method: "POST"
//            ) as [String: String]
//
//            await TokenManager.shared.saveTokens(access: "", refresh: "")
//            self.isSignedIn = false
//            
//            // Clear user data
//            self.fullName = nil
//            self.email = nil
//            self.profileImageURL = nil
//        }
//    }
//}
//
//// MARK: - Apple Sign In Delegates (NEW)
//extension AuthenticationViewModel: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
//    
//    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
//        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
//            print("Apple Sign In successful")
//            
//            // Get the identity token
//            guard let identityTokenData = appleIDCredential.identityToken,
//                  let identityToken = String(data: identityTokenData, encoding: .utf8) else {
//                print("Failed to get identity token")
//                return
//            }
//            
//            print("Got Apple ID Token:", identityToken)
//            
//            // Extract user information (only available on first sign-in)
//            if let fullName = appleIDCredential.fullName {
//                let firstName = fullName.givenName ?? ""
//                let lastName = fullName.familyName ?? ""
//                self.fullName = "\(firstName) \(lastName)".trimmingCharacters(in: .whitespaces)
//                if self.fullName?.isEmpty == true {
//                    self.fullName = nil
//                }
//            }
//            
//            if let email = appleIDCredential.email {
//                self.email = email
//            }
//            
//            // Sign in with backend
//            Task {
//                await signInWithBackend(idToken: identityToken, provider: "apple")
//            }
//        }
//    }
//    
//    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
//        print("Apple Sign In failed with error: \(error)")
//        
//        if let authError = error as? ASAuthorizationError {
//            switch authError.code {
//            case .canceled:
//                print("User canceled Apple Sign In")
//            case .failed:
//                print("Apple Sign In failed")
//            case .invalidResponse:
//                print("Apple Sign In invalid response")
//            case .notHandled:
//                print("Apple Sign In not handled")
//            case .unknown:
//                print("Apple Sign In unknown error")
//            @unknown default:
//                print("Apple Sign In unknown error")
//            }
//        }
//    }
//    
//    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
//        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
//              let window = windowScene.windows.first else {
//            fatalError("No window available for Apple Sign In presentation")
//        }
//        return window
//    }
//}



//
//  AuthenticationViewModel.swift
//  SmartSpend
//
//  Created by Refik Jaija on 17.8.25.
//
//
import Foundation
import SwiftUI
import GoogleSignIn
import AuthenticationServices

@MainActor
class AuthenticationViewModel: NSObject, ObservableObject {
    @Published var isSignedIn = false
    @Published var fullName: String?
    @Published var email: String?
    @Published var profileImageURL: String?
    @EnvironmentObject var userVM: UserViewModel
    @EnvironmentObject var categoryVM: CategoryViewModel
    
    // MARK: - Google Sign In (existing code - unchanged)
    func signIn() {
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
                self?.setSignedIn(user: user)
            }
        }
    }

    private func setSignedIn(user: GIDGoogleUser) {
        fullName = user.profile?.name
        email = user.profile?.email

        // Get ID Token and Access Token
        let idToken = user.idToken?.tokenString
        let accessToken = user.accessToken.tokenString

        print("Got ID Token:", idToken ?? "nil")
        print("Got Access Token:", accessToken)

        Task {
            await signInWithBackend(idToken: idToken ?? "", provider: "google")
        }
    }

    // MARK: - Apple Sign In (NEW)
    func signInWithApple() {
        print("DEBUG: Apple Sign In button tapped")
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
        print("DEBUG: Apple Sign In request initiated")
    }

    // MARK: - Common Backend Sign In (UPDATED)
    private func signInWithBackend(idToken: String, provider: String) async {
        print("DEBUG: Starting backend sign in for provider: \(provider)")
        print("DEBUG: ID Token: \(idToken)")
        
        do {
            struct SignInResponse: Decodable {
                let message: String
                let access_token: String
                let refresh_token: String
                let refresh_token_expiry_date: String?
                let user_data: UserData?
            }
            
            struct UserData: Decodable {
                let id: String
                let email: String
                let firstName: String?
                let lastName: String?
            }

            print("DEBUG: Making API request to: api/auth/\(provider)")
            
            // Send the idToken to the backend
            let response: SignInResponse = try await APIClient.shared.request(
                endpoint: "api/auth/\(provider)",
                method: "POST",
                body: ["id_token": idToken]
            )
            
            // Detailed logging
            print("DEBUG: Backend response received successfully")
            print("DEBUG: Message:", response.message)
            print("DEBUG: Access Token received:", !response.access_token.isEmpty)
            print("DEBUG: Refresh Token received:", !response.refresh_token.isEmpty)

            // UPDATED: Save tokens with expiry date
            await TokenManager.shared.saveTokens(
                access: response.access_token,
                refresh: response.refresh_token,
                refreshExpiryDate: response.refresh_token_expiry_date
            )
            
            // Update user data if available
            if let userData = response.user_data {
                self.fullName = "\(userData.firstName ?? "") \(userData.lastName ?? "")".trimmingCharacters(in: .whitespaces)
                if self.fullName?.isEmpty == true {
                    self.fullName = nil
                }
                self.email = userData.email
                print("DEBUG: User data updated - Name: \(self.fullName ?? "nil"), Email: \(self.email ?? "nil")")
            }

            // Uncomment these when ready
            // await userVM.fetchUser()
            // await categoryVM.fetchCategories()
            
            DispatchQueue.main.async {
                self.isSignedIn = true
                print("DEBUG: User marked as signed in via \(provider)")
            }
        } catch {
            print("ERROR: Sign in failed with error: \(error)")
            if let urlError = error as? URLError {
                print("ERROR: URL Error code: \(urlError.code)")
                print("ERROR: URL Error description: \(urlError.localizedDescription)")
            }
        }
    }

    func signOut() {
        Task {
            _ = try? await APIClient.shared.request(
                endpoint: "/auth/logout",
                method: "POST"
            ) as [String: String]

            await TokenManager.shared.saveTokens(access: "", refresh: "")
            self.isSignedIn = false
            
            // Clear user data
            self.fullName = nil
            self.email = nil
            self.profileImageURL = nil
        }
    }
}

// MARK: - Apple Sign In Delegates (NEW)
extension AuthenticationViewModel: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            print("DEBUG: Apple Sign In successful")
            print("DEBUG: User ID:", appleIDCredential.user)
            print("DEBUG: Email:", appleIDCredential.email ?? "nil")
            print("DEBUG: Full Name:", appleIDCredential.fullName?.description ?? "nil")
            print("DEBUG: Authorized Scopes:", appleIDCredential.authorizedScopes)
            
            // Get the identity token
            guard let identityTokenData = appleIDCredential.identityToken,
                  let identityToken = String(data: identityTokenData, encoding: .utf8) else {
                print("ERROR: Failed to get identity token")
                print("DEBUG: Identity token data:", appleIDCredential.identityToken ?? "nil")
                return
            }
            
            print("DEBUG: Got Apple ID Token (length: \(identityToken.count))")
            
            // Extract user information (only available on first sign-in)
            if let fullName = appleIDCredential.fullName {
                let firstName = fullName.givenName ?? ""
                let lastName = fullName.familyName ?? ""
                self.fullName = "\(firstName) \(lastName)".trimmingCharacters(in: .whitespaces)
                if self.fullName?.isEmpty == true {
                    self.fullName = nil
                }
                print("DEBUG: Extracted name from Apple:", self.fullName ?? "nil")
            } else {
                print("DEBUG: No name provided by Apple (subsequent sign-in)")
            }
            
            if let email = appleIDCredential.email {
                self.email = email
                print("DEBUG: Extracted email from Apple:", email)
            } else {
                print("DEBUG: No email provided by Apple (subsequent sign-in)")
            }
            
            // Sign in with backend
            Task {
                await signInWithBackend(idToken: identityToken, provider: "apple")
                print(identityToken)
            }
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Apple Sign In failed with error: \(error)")
        
        if let authError = error as? ASAuthorizationError {
            switch authError.code {
            case .canceled:
                print("User canceled Apple Sign In")
            case .failed:
                print("Apple Sign In failed")
            case .invalidResponse:
                print("Apple Sign In invalid response")
            case .notHandled:
                print("Apple Sign In not handled")
            case .unknown:
                print("Apple Sign In unknown error")
            @unknown default:
                print("Apple Sign In unknown error")
            }
        }
    }
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            fatalError("No window available for Apple Sign In presentation")
        }
        return window
    }
}
