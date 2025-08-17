//
//  AppleAuthService.swift
//  SmartSpend
//
//  Created by shortcut mac on 17.8.25.
//

import Foundation
import AuthenticationServices
import UIKit

/// Performs Sign in with Apple (ASAuthorizationController) and returns ProviderToken
final class AppleAuthService: NSObject {
    private var appleContinuation: CheckedContinuation<ProviderToken, Error>?
    private var currentRawNonce: String?

    /// Start Sign in with Apple and return ProviderToken
    func signIn() async throws -> ProviderToken {
        let raw = randomNonceString()
        currentRawNonce = raw
        let hashed = sha256Hex(raw)

        return try await withCheckedThrowingContinuation { continuation in
            self.appleContinuation = continuation

            let request = ASAuthorizationAppleIDProvider().createRequest()
            request.requestedScopes = [.email, .fullName]
            request.nonce = hashed

            let controller = ASAuthorizationController(authorizationRequests: [request])
            controller.delegate = self
            controller.presentationContextProvider = self
            controller.performRequests()
        }
    }
}

extension AppleAuthService: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first { $0.activationState == .foregroundActive } as? UIWindowScene
        return windowScene?.windows.first { $0.isKeyWindow } ?? ASPresentationAnchor()
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        defer { appleContinuation = nil; currentRawNonce = nil }

        guard let cred = authorization.credential as? ASAuthorizationAppleIDCredential else {
            appleContinuation?.resume(throwing: NSError(domain: "AppleAuth", code: 1, userInfo: [NSLocalizedDescriptionKey: "No Apple credential"]))
            return
        }

        let userId = cred.user
        let email = cred.email
        let given = cred.fullName?.givenName
        let family = cred.fullName?.familyName

        if let idTokenData = cred.identityToken, let idToken = String(data: idTokenData, encoding: .utf8) {
            let authCodeString = cred.authorizationCode.flatMap { String(data: $0, encoding: .utf8) }
            let token = ProviderToken(provider: "apple",
                                      idToken: idToken,
                                      authorizationCode: authCodeString,
                                      rawNonce: currentRawNonce,
                                      userID: userId,
                                      email: email,
                                      givenName: given,
                                      familyName: family)
            appleContinuation?.resume(returning: token)
            return
        }

        if let authCodeString = cred.authorizationCode.flatMap({ String(data: $0, encoding: .utf8) }) {
            let token = ProviderToken(provider: "apple",
                                      idToken: nil,
                                      authorizationCode: authCodeString,
                                      rawNonce: currentRawNonce,
                                      userID: userId,
                                      email: email,
                                      givenName: given,
                                      familyName: family)
            appleContinuation?.resume(returning: token)
            return
        }

        appleContinuation?.resume(throwing: NSError(domain: "AppleAuth", code: 2, userInfo: [NSLocalizedDescriptionKey: "Missing token"]))
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        appleContinuation?.resume(throwing: error)
        appleContinuation = nil
        currentRawNonce = nil
    }
}
