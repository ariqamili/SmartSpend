import Foundation

// MARK: - Custom Errors
public enum AuthError: LocalizedError {
    case missingIdToken
    case noRefreshTokenFromBackend
    case noRefreshToken
    case refreshTokenExpired
    case invalidCredential

    public var errorDescription: String? {
        switch self {
        case .missingIdToken:
            return "Apple authentication failed: missing ID token"
        case .noRefreshTokenFromBackend:
            return "Backend authentication failed: no refresh token received"
        case .noRefreshToken:
            return "No refresh token found. Please sign in again."
        case .refreshTokenExpired:
            return "Session expired. Please sign in again."
        case .invalidCredential:
            return "Invalid authentication credential received"
        }
    }
}
