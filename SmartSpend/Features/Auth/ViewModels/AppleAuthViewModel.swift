//
//  AppleAuthViewModel.swift
//  SmartSpend
//
//  Created by shortcut mac on 17.8.25.
//

import Foundation
import AuthenticationServices
import SwiftUI

@MainActor
final class AppleAuthViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var isAuthenticated = false

    @AppStorage("email") private(set) var email: String = ""
    @AppStorage("firstName") private(set) var firstName: String = ""
    @AppStorage("lastName") private(set) var lastName: String = ""
    @AppStorage("userID") private(set) var userID: String = ""

    private var currentRawNonce: String?
    private let network: AuthNetworking

    init(networking: AuthNetworking = MockAuthNetworking()) {
        self.network = networking
    }

    /// Called by the View to get the hashed nonce to set on the Apple request.
    /// The View will set `request.nonce = vm.prepareNonceForRequest()`
    func prepareNonceForRequest() -> String {
        let raw = randomNonceString()
        currentRawNonce = raw
        return sha256Hex(raw)
    }

    /// Called by the View when SignInWithAppleButton's onCompletion fires.
    /// Pass the Result<ASAuthorization, Error> here.
    func handleAuthorizationResult(_ result: Result<ASAuthorization, Error>) {
        Task {
            await process(result)
        }
    }

    private func process(_ result: Result<ASAuthorization, Error>) async {
        isLoading = true
        defer { isLoading = false }

        switch result {
        case .failure(let error):
            errorMessage = error.localizedDescription
            return

        case .success(let authorization):
            guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential else {
                errorMessage = "Unsupported credential"
                return
            }

            let userId = credential.user
            let emailVal = credential.email
            let given = credential.fullName?.givenName
            let family = credential.fullName?.familyName

            // Extract identityToken if available
            var idTokenString: String? = nil
            if let tokenData = credential.identityToken {
                idTokenString = String(data: tokenData, encoding: .utf8)
            }
            var authCodeString: String? = nil
            if let codeData = credential.authorizationCode {
                authCodeString = String(data: codeData, encoding: .utf8)
            }

            // Build ProviderToken (your model)
            let providerToken = ProviderToken(
                provider: "apple",
                idToken: idTokenString,
                authorizationCode: authCodeString,
                rawNonce: currentRawNonce,
                userID: userId,
                email: emailVal,
                givenName: given,
                familyName: family
            )

            // If you have a backend, send the token (mock by default)
            do {
                let sessionToken = try await network.sendProviderToken(providerToken)
                if let s = sessionToken {
                    KeychainHelper.standard.save(token: s, for: "session_token")
                }
                // persist visible user data
                if let uid = providerToken.userID { userID = uid }
                if let e = providerToken.email { email = e }
                if let g = providerToken.givenName { firstName = g }
                if let f = providerToken.familyName { lastName = f }

                isAuthenticated = true
            } catch {
                errorMessage = error.localizedDescription
            }
            // clear nonce after processing
            currentRawNonce = nil
        }
    }
}
