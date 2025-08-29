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


    private func setSignedIn(user: GIDGoogleUser) {
        fullName = user.profile?.name
        email = user.profile?.email

        // Get ID Token and Access Token
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

                // send the idToken
                let response: SignInResponse = try await APIClient.shared.request(
                    endpoint: "api/auth/google",
                    method: "POST",
                    body: ["id_token": idToken ?? ""]
                )
                
                //  Detailed logging
                print("   Backend response received")
                print("   Message:", response.message)
                print("   Access Token:", response.access_token)
                print("   Refresh Token:", response.refresh_token)

                await TokenManager.shared.saveTokens(
                    access: response.access_token,
                    refresh: response.refresh_token
                )

    //            await userVM.fetchUser()
    //            await categoryVM.fetchCategories()
                
                DispatchQueue.main.async {
                    self.isSignedIn = true
                    print("User marked as signed in")
                }
            } catch {
                print("Sign in failed with error:", error)
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
