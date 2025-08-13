//
//  ContentView.swift
//  SmartSpend
//
//  Created by shortcut mac on 13.8.25.
//

//import SwiftUI
//import AuthenticationServices
//
//struct ContentView: View {
//    @Environment (\.colorScheme) var colorScheme
//
//    @AppStorage ("email") var email: String = ""
//    @AppStorage ("firstName") var firstName: String = ""
//    @AppStorage ("lastName") var lastName: String = ""
//    @AppStorage ("userID") var userID: String = ""
//
//    var body: some View {
//        NavigationStack{
//            VStack {
//
//                if userID.isEmpty {
//
//                    SignInWithAppleButton (.continue){ request in
//                        request.requestedScopes = [.email, .fullName]
//    //                    print(request)
//                    } onCompletion: { result in
//
//                        switch result {
//                        case .success(let auth):
//
//                            switch auth.credential {
//                            case let credential as ASAuthorizationAppleIDCredential:
//
//                                let userId = credential.user
//
//                                let email = credential.email
//                                let firstName = credential.fullName?.givenName
//                                let lastName = credential.fullName?.familyName
//
//
//                                self.email = email ?? ""
//                                self.userID = userId
//                                self.firstName = firstName ?? ""
//                                self.lastName = lastName ?? ""
//
//                            default:
//                                break
//                            }
//
//                        case .failure(let error):
//                            print(error)
//                        }
////                        print(result)
//                    }
//                    .signInWithAppleButtonStyle(
//                        colorScheme == .dark ? .white : .black
//                    )
//                    .frame(width: 300, height: 50)
//                }
//                else{
//                    //signedIn Page
//                }
//
//            }
//            .navigationTitle("Sign in")
//        }
//
//    }
//}
//
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}





//
//  ContentView.swift
//  SmartSpend
//
//  Created by shortcut mac on 13.8.25.
//

import SwiftUI
import AuthenticationServices
import CryptoKit
import Security
import Foundation

struct ContentView: View {
    @Environment(\.colorScheme) var colorScheme

    // user info
    @AppStorage("email") var email: String = ""
    @AppStorage("firstName") var firstName: String = ""
    @AppStorage("lastName") var lastName: String = ""
    @AppStorage("userID") var userID: String = ""

    // optional session indicator (you may keep session token in Keychain)
    @AppStorage("isSignedIn") var isSignedIn: Bool = false

    // local UI state
    @State private var currentNonce: String?
    @State private var isLoading = false
    @State private var errorMessage: String?

    // change to your backend URL
    private let backendBaseURL = URL(string: "https://api.smartspend.example")! // <-- UPDATE

    var body: some View {
        NavigationStack {
            VStack {
                if userID.isEmpty {
                    VStack(spacing: 16) {
                        if isLoading {
                            ProgressView()
                        }

                        SignInWithAppleButton(.continue) { request in
                            // generate raw nonce and set hashed nonce on the request
                            let raw = randomNonceString()
                            currentNonce = raw
                            request.requestedScopes = [.email, .fullName]
                            request.nonce = sha256Hex(raw)
                        } onCompletion: { result in
                            switch result {
                            case .success(let auth):
                                switch auth.credential {
                                case let credential as ASAuthorizationAppleIDCredential:
                                    // user identifier
                                    let userId = credential.user
                                    // name & email may be nil on subsequent sign-ins
                                    let emailValue = credential.email
                                    let first = credential.fullName?.givenName
                                    let last = credential.fullName?.familyName

                                    // Save basic profile info locally (as you already did)
                                    self.email = emailValue ?? ""
                                    self.userID = userId
                                    self.firstName = first ?? ""
                                    self.lastName = last ?? ""

                                    // convert identityToken & authorizationCode from Data? to String?
                                    var idTokenString: String?
                                    if let tokenData = credential.identityToken {
                                        idTokenString = String(data: tokenData, encoding: .utf8)
                                    }
                                    var authCodeString: String?
                                    if let codeData = credential.authorizationCode {
                                        authCodeString = String(data: codeData, encoding: .utf8)
                                    }

                                    // Send to backend (async)
                                    Task {
                                        await sendAppleTokenToBackend(idToken: idTokenString, authorizationCode: authCodeString, rawNonce: currentNonce)
                                    }

                                default:
                                    print("Unhandled credential type: \(auth.credential)")
                                }

                            case .failure(let error):
                                print("Apple sign-in failed:", error.localizedDescription)
                                errorMessage = error.localizedDescription
                            }
                        }
                        .signInWithAppleButtonStyle(colorScheme == .dark ? .white : .black)
                        .frame(width: 300, height: 50)

                        if let err = errorMessage {
                            Text(err)
                                .foregroundColor(.red)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                        }
                    }
                } else {
                    // Signed in page — update this to your app's main view
                    VStack(spacing: 12) {
                        Text("Welcome, \(firstName.isEmpty ? "User" : firstName)")
                            .font(.title2)
                            .bold()
                        Text(email)
                            .font(.subheadline)
                            .foregroundColor(.secondary)

                        Button("Sign out") {
                            signOut()
                        }
                        .buttonStyle(.bordered)
                    }
                }
            }
            .navigationTitle("Sign in")
        }
    }

    // MARK: - Send token to backend
    private func sendAppleTokenToBackend(idToken: String?, authorizationCode: String?, rawNonce: String?) async {
        isLoading = true
        errorMessage = nil

        defer { isLoading = false }

        // id_token should be present on successful sign-in; if not, backend would need auth code flow
        guard idToken != nil || authorizationCode != nil else {
            errorMessage = "Apple sign-in returned no token or auth code."
            return
        }

        let url = backendBaseURL.appendingPathComponent("/auth/social")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        var payload: [String: Any] = ["provider": "apple"]
        if let id = idToken { payload["id_token"] = id }
        if let code = authorizationCode { payload["authorization_code"] = code }
        if let raw = rawNonce { payload["raw_nonce"] = raw }

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: payload, options: [])
        } catch {
            errorMessage = "Failed to build request payload: \(error.localizedDescription)"
            return
        }

        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let http = response as? HTTPURLResponse else {
                errorMessage = "Invalid response from server."
                return
            }
            guard (200...299).contains(http.statusCode) else {
                let body = String(data: data, encoding: .utf8) ?? "no body"
                errorMessage = "Server error: \(http.statusCode) — \(body)"
                return
            }

            // Expect { "session_token": "<jwt>", ... } — save session token to Keychain
            if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let sessionToken = json["session_token"] as? String {
                KeychainHelper.standard.save(token: sessionToken, for: "session_token")
                isSignedIn = true
            } else {
                // If backend returns no session token but accepted, just mark signed in.
                isSignedIn = true
            }
        } catch {
            errorMessage = "Network error: \(error.localizedDescription)"
        }
    }

    // MARK: - Sign out
    private func signOut() {
        // clear stored user info + session
        email = ""
        firstName = ""
        lastName = ""
        userID = ""
        isSignedIn = false
        // remove Keychain session token if used
        KeychainHelper.standard.delete(for: "session_token")
    }
}

// -----------------------------
// MARK: - Nonce helpers
// -----------------------------
func randomNonceString(length: Int = 32) -> String {
    precondition(length > 0)
    let charset: Array<Character> =
    Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
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

func sha256Hex(_ input: String) -> String {
    let hashed = SHA256.hash(data: Data(input.utf8))
    return hashed.compactMap { String(format: "%02x", $0) }.joined()
}

// -----------------------------
// MARK: - Minimal Keychain helper
// -----------------------------
final class KeychainHelper {
    static let standard = KeychainHelper()
    private init() {}

    func save(token: String, for key: String) {
        guard let data = token.data(using: .utf8) else { return }
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data
        ]
        SecItemDelete(query as CFDictionary)
        SecItemAdd(query as CFDictionary, nil)
    }

    func read(for key: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        var dataRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataRef)
        guard status == errSecSuccess, let data = dataRef as? Data else { return nil }
        return String(data: data, encoding: .utf8)
    }

    func delete(for key: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]
        SecItemDelete(query as CFDictionary)
    }
}

// -----------------------------
// MARK: - Preview
// -----------------------------
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
