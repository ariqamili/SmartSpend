//
//  CryptoNonce.swift
//  SmartSpend
//
//  Created by shortcut mac on 17.8.25.
//

import Foundation
import CryptoKit
import Security

/// Generate cryptographically secure random nonce (allowed chars per Apple docs)
func randomNonceString(length: Int = 32) -> String {
    precondition(length > 0)
    let charset: Array<Character> = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
    var result = ""
    var remaining = length

    while remaining > 0 {
        var random: UInt8 = 0
        let status = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
        if status != errSecSuccess { continue }
        if random < charset.count {
            result.append(charset[Int(random) % charset.count])
            remaining -= 1
        }
    }
    return result
}

/// SHA-256 hex used to set request.nonce for Sign in with Apple
func sha256Hex(_ input: String) -> String {
    let hashed = SHA256.hash(data: Data(input.utf8))
    return hashed.compactMap { String(format: "%02x", $0) }.joined()
}

