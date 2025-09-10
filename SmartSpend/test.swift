//
//  test.swift
//  SmartSpend
//
//  Created by shortcut mac on 9.9.25.
//

import SwiftUI
import AuthenticationServices

struct Test: View {
    var body: some View {
        SignInWithAppleButton(.signUp) { request in
            // ✅ request both fullName and email scopes
            request.requestedScopes = [.fullName, .email]
        } onCompletion: { result in
            switch result {
            case .success(let authorization):
                handleSuccessfulLogin(with: authorization)
            case .failure(let error):
                handleLoginError(with: error)
            }
        }
        .frame(height: 50)
        .padding()
    }
    
    private func handleSuccessfulLogin(with authorization: ASAuthorization) {
        if let userCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            
            print(userCredential)
            
            print("------------------")
            // Always available: stable user id
            print("User ID: \(userCredential.user)")
            
            // ✅ On first sign-up, these will be filled if user granted scopes
            if let fullName = userCredential.fullName {
                let given = fullName.givenName ?? ""
                let family = fullName.familyName ?? ""
                print("Full name: \(given) \(family)")
            } else {
                print("No full name provided (or this is not first sign in)")
            }
            
            if let email = userCredential.email {
                print("Email: \(email)")
            } else {
                print("No email provided (or this is not first sign in)")
            }
        }
    }
    
    private func handleLoginError(with error: Error) {
        print("Could not authenticate: \(error.localizedDescription)")
    }
}

#Preview {
    Test()
}
