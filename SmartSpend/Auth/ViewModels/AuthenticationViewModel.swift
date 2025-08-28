//
//  AuthenticationViewModel.swift
//  SmartSpend
//
//  Created by Refik Jaija on 17.8.25.
//
//
//

//import Foundation
//import SwiftUI
//import GoogleSignIn
//
//class AuthenticationViewModel: ObservableObject {
//    @Published var isSignedIn = false
//    @Published var idToken: String?
//    @Published var fullName: String?
//    @Published var email: String?
//    @Published var profileImageURL: URL?
//
//    init() {
//        //restoreSignIn()
//    }
//
//    func restoreSignIn() {
//        if let user = GIDSignIn.sharedInstance.currentUser {
//            setSignedIn(user: user)
//        } else {
//            GIDSignIn.sharedInstance.restorePreviousSignIn { [weak self] user, error in
//                if let user = user, error == nil {
//                    self?.setSignedIn(user: user)
//                }
//            }
//        }
//    }
//
//    func signIn() {
//        guard let rootVC = UIApplication.shared.connectedScenes
//                .compactMap({ $0 as? UIWindowScene })
//                .first?.windows.first?.rootViewController else { return }
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
//    func signOut() {
//        GIDSignIn.sharedInstance.signOut()
//        isSignedIn = false
//        idToken = nil
//        fullName = nil
//        email = nil
//        profileImageURL = nil
//        print("User signed out")
//    }
//
//    private func setSignedIn(user: GIDGoogleUser) {
//        // Store user info in @Published vars
//        fullName = user.profile?.name
//        email = user.profile?.email
//        if user.profile?.hasImage == true {
//            profileImageURL = user.profile?.imageURL(withDimension: 200)
//        }
//        idToken = user.idToken?.tokenString
//
//        // Print to console (for debugging)
//        print("Full Name:", fullName ?? "N/A")
//        print("Email:", email ?? "N/A")
//        print("Profile Image URL:", profileImageURL?.absoluteString ?? "N/A")
//        print("ID Token:", idToken ?? "N/A")
//
//        DispatchQueue.main.async {
//            self.isSignedIn = true
//            if let token = self.idToken {
//                // Temporarily disabled backend call for testing
//                self.sendTokenToBackend(token)
//                
//                // Just print token for now
//                print("DEBUG: Would send token to backend:", token)
//            }
//        }
//    }
//
//    private func sendTokenToBackend(_ token: String) {
//        guard let url = URL(string: "https://96aed091191d.ngrok-free.app/api/auth/google") else { return }
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.httpBody = try? JSONEncoder().encode(["id_token": token])
//        URLSession.shared.dataTask(with: request).resume()
//    }
//}
//




import Foundation
import SwiftUI
import GoogleSignIn

@MainActor
class AuthenticationViewModel: ObservableObject {
    @Published var isSignedIn = false
    @Published var fullName: String?
    @Published var email: String?
    @Published var profileImageURL: String?
    @EnvironmentObject var userVM: UserViewModel
    @EnvironmentObject var categoryVM: CategoryViewModel
    

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

//    func setSignedIn(user: GIDGoogleUser) {
//        let idToken = user.idToken?.tokenString ?? ""
//        print("Got ID Token:", idToken)
//
//        Task {
//            struct SignInResponse: Decodable {
//                let message: String
//                let refresh_token: String
//                let access_token: String
//            }
//
//            do {
//                let response: SignInResponse = try await APIClient.shared.request(
//                    endpoint: "api/auth/google",
//                    method: "POST",
//                    body: ["id_token": idToken]
//                )
//
//                await TokenManager.shared.saveTokens(
//                    access: response.access_token,
//                    refresh: response.refresh_token
//                )
//                
//                
////                await userVM.fetchUser()
////                await categoryVM.fetchCategories()
//                
//
//                DispatchQueue.main.async {
//                    self.fullName = user.profile?.name
//                    self.isSignedIn = true
//                }
//            } catch {
//                print("Sign in failed:", error)
//            }
//        }
//    }
    
    private func setSignedIn(user: GIDGoogleUser) {
        fullName = user.profile?.name
        email = user.profile?.email

        // ✅ Get ID Token and Access Token
        let idToken = user.idToken?.tokenString
        let accessToken = user.accessToken.tokenString

        print("Got ID Token:", idToken ?? "nil")
        print("Got Access Token:", accessToken)

        Task {
            do {
                struct SignInResponse: Decodable {
                    let message: String
                    let access_token: String
                    let refresh_token: String
                }

                // 👇 send the idToken (backend must verify against iOS client ID)
                let response: SignInResponse = try await APIClient.shared.request(
                    endpoint: "api/auth/google",
                    method: "POST",
                    body: ["id_token": idToken ?? ""]
                )

                await TokenManager.shared.saveTokens(
                    access: response.access_token,
                    refresh: response.refresh_token
                )

//                await userVM.fetchUser()
//                await categoryVM.fetchCategories()
                
                DispatchQueue.main.async {
                    self.isSignedIn = true
                }
            } catch {
                print("Sign in failed:", error)
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
        }
    }
}
