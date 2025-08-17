//
//  AuthenticationViewModel.swift
//  SmartSpend
//
//  Created by Refik Jaija on 17.8.25.
//

import Foundation
import SwiftUI
import GoogleSignIn

class AuthenticationViewModel: ObservableObject {
    @Published var isSignedIn = false
    @Published var idToken: String?
    @Published var fullName: String?
    @Published var email: String?
    @Published var profileImageURL: URL?

    init() {
        restoreSignIn()
    }

    func restoreSignIn() {
        if let user = GIDSignIn.sharedInstance.currentUser {
            setSignedIn(user: user)
        } else {
            GIDSignIn.sharedInstance.restorePreviousSignIn { [weak self] user, error in
                if let user = user, error == nil {
                    self?.setSignedIn(user: user)
                }
            }
        }
    }

    func signIn() {
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

    func signOut() {
        GIDSignIn.sharedInstance.signOut()
        isSignedIn = false
        idToken = nil
        fullName = nil
        email = nil
        profileImageURL = nil
        print("User signed out")
    }

    private func setSignedIn(user: GIDGoogleUser) {
        // Store user info in @Published vars
        fullName = user.profile?.name
        email = user.profile?.email
        if user.profile?.hasImage == true {
            profileImageURL = user.profile?.imageURL(withDimension: 200)
        }
        idToken = user.idToken?.tokenString

        // Print to console (for debugging)
        print("Full Name:", fullName ?? "N/A")
        print("Email:", email ?? "N/A")
        print("Profile Image URL:", profileImageURL?.absoluteString ?? "N/A")
        print("ID Token:", idToken ?? "N/A")

        DispatchQueue.main.async {
            self.isSignedIn = true
            if let token = self.idToken {
                // Temporarily disabled backend call for testing
                //self.sendTokenToBackend(token)
                
                // Just print token for now
                print("DEBUG: Would send token to backend:", token)
            }
        }
    }

    private func sendTokenToBackend(_ token: String) {
        guard let url = URL(string: "https://your.backend/login") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(["idToken": token])
        URLSession.shared.dataTask(with: request).resume()
    }
}
