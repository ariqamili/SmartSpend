//
//  AuthConstants.swift
//  SmartSpend
//
//  Created by shortcut mac on 17.8.25.
//

import Foundation

public enum AuthConstants {
    // Update these URLs to match your actual backend
    static let backendBaseURL = URL(string: "https://347f60f79265.ngrok-free.app/api/auth/signin/apple")!
    static let authEndpointPath = "/auth/social"
    static let refreshEndpointPath = "/auth/refresh"
    
    // Token storage keys
    enum KeychainKeys {
        static let refreshToken = "refresh_token"
        static let refreshTokenExpiry = "refresh_token_expiry"
        static let accessToken = "access_token"
        static let accessTokenExpiry = "access_token_expiry"
    }
    
    // Token expiration times (in seconds)
    enum TokenExpiration {
        static let accessToken: TimeInterval = 1800 // 30 minutes
        static let refreshToken: TimeInterval = 2592000 // 30 days
    }
}
