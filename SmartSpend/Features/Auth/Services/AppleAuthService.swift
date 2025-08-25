//
//  AppleAuthService.swift
//  SmartSpend
//
//  Created by shortcut mac on 20.8.25.
//

import Foundation
import AuthenticationServices
import UIKit

/// Performs Sign in with Apple and returns ProviderToken with ID token
final class AppleAuthService: NSObject {
    private var appleContinuation: CheckedContinuation<ProviderToken, Error>?
    private var currentRawNonce: String?

    /// Start Sign in with Apple and return ProviderToken with ID token
    func signIn() async throws -> ProviderToken {
        let rawNonce = randomNonceString()
        currentRawNonce = rawNonce
        let hashedNonce = sha256Hex(rawNonce)

        return try await withCheckedThrowingContinuation { continuation in
            self.appleContinuation = continuation

            let request = ASAuthorizationAppleIDProvider().createRequest()
            request.requestedScopes = [.email, .fullName]
            request.nonce = hashedNonce

            let controller = ASAuthorizationController(authorizationRequests: [request])
            controller.delegate = self
            controller.presentationContextProvider = self
            controller.performRequests()
        }
    }
}

extension AppleAuthService: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first(where: { $0.isKeyWindow }) else {
            return ASPresentationAnchor()
        }
        return window
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        defer {
            appleContinuation = nil
            currentRawNonce = nil
        }

        guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential else {
            appleContinuation?.resume(throwing: AuthError.invalidCredential)
            return
        }

        // IMPORTANT: We need the ID token for your backend flow
        guard let identityTokenData = credential.identityToken,
              let identityToken = String(data: identityTokenData, encoding: .utf8) else {
            appleContinuation?.resume(throwing: AuthError.missingIdToken)
            return
        }

        let authCode = credential.authorizationCode.flatMap { String(data: $0, encoding: .utf8) }
        
        let providerToken = ProviderToken(
            provider: "apple",
            idToken: identityToken,
            authorizationCode: authCode,
            rawNonce: currentRawNonce,
            userID: credential.user,
            email: credential.email,
            givenName: credential.fullName?.givenName,
            familyName: credential.fullName?.familyName
        )

        appleContinuation?.resume(returning: providerToken)
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        appleContinuation?.resume(throwing: error)
        appleContinuation = nil
        currentRawNonce = nil
    }
}
