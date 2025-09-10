//////
//////  LoginView.swift
//////  SmartSpend
//////
//////  Created by Refik Jaija on 17.8.25.
//////
////
////import SwiftUI
////import GoogleSignInSwift
////
////struct LoginView: View {
////    @EnvironmentObject var authVM: AuthenticationViewModel
////
////
////    var body: some View {
////        VStack(spacing: 20) {
////            Spacer()
////            Text("Welcom to Smart Spend")
////                .font(.system(size: 40))
////                .frame(maxWidth: .infinity, alignment: .leading)
////                .foregroundStyle(Color.MainColor)
////            Text("Enjoy all the features that make it easy for you to manage your finances, and receive rich insights.")
////                .font(.system(size: 15))
////                .frame(maxWidth: 350, alignment: .leading)
////                .foregroundStyle(.gray)
////            
////            Spacer()
////
//////            GoogleSignInButton(action: authVM.signIn)
//////                .frame(height: 50)
//////                .padding()
////  
////            Button(action: {
////                authVM.signIn()
////            }) {
////                HStack {
////                    Image("googleLogo")
////                        .resizable()
////                        .frame(width: 24, height: 24)
////                    
////                    Text("Continue with Google")
////                        .foregroundStyle(.black)
////                }
////                .frame(maxWidth: .infinity, minHeight: 60)
////                .background(Color.white)
////                .cornerRadius(12)
////                .shadow(radius: 2)
////            }
////            .padding(.horizontal)
////            
////            Spacer()
////            Spacer()
////
////        
////        }
////        .padding()
////    }
////}
////
////#Preview {
////    LoginView()
////        .environmentObject(AuthenticationViewModel()) 
////}
//
//
//
////
////  LoginView.swift
////  SmartSpend
////
////  Created by Refik Jaija on 17.8.25.
////
//
//import SwiftUI
//import GoogleSignInSwift
//import AuthenticationServices
//
//struct LoginView: View {
//    @EnvironmentObject var authVM: AuthenticationViewModel
//
//    var body: some View {
//        VStack(spacing: 20) {
//            Spacer()
//            Text("Welcome to Smart Spend")
//                .font(.system(size: 40))
//                .frame(maxWidth: .infinity, alignment: .leading)
//                .foregroundStyle(Color.MainColor)
//            Text("Enjoy all the features that make it easy for you to manage your finances, and receive rich insights.")
//                .font(.system(size: 15))
//                .frame(maxWidth: 350, alignment: .leading)
//                .foregroundStyle(.gray)
//            
//            Spacer()
//
//            // Google Sign In Button (existing)
//            Button(action: {
//                authVM.signIn()
//            }) {
//                HStack {
//                    Image("googleLogo")
//                        .resizable()
//                        .frame(width: 24, height: 24)
//                    
//                    Text("Continue with Google")
//                        .foregroundStyle(.black)
//                }
//                .frame(maxWidth: .infinity, minHeight: 60)
//                .background(Color.white)
//                .cornerRadius(12)
//                .shadow(radius: 2)
//            }
//            .padding(.horizontal)
//            
//            // Apple Sign In Button (NEW)
//            Button(action: {
                authVM.signInWithApple()
//            }) {
//                HStack {
//                    Image(systemName: "apple.logo")
//                        .font(.system(size: 24))
//                        .foregroundStyle(.white)
//                    
//                    Text("Continue with Apple")
//                        .foregroundStyle(.white)
//                }
//                .frame(maxWidth: .infinity, minHeight: 60)
//                .background(Color.black)
//                .cornerRadius(12)
//            }
//            .padding(.horizontal)
//            
//            // Alternative: Native Apple Sign In Button (you can use this instead if preferred)
//            
////            SignInWithAppleButton(.signIn) { request in
////                request.requestedScopes = [.fullName, .email]
////            } onCompletion: { result in
////                switch result {
////                case .success(let authorization):
////                    // Handle in AuthenticationViewModel
////                    print(result)
////                    break
////                case .failure(let error):
////                    print("Apple Sign In error: \(error)")
////                }
////            }
////            .signInWithAppleButtonStyle(.black)
////            .frame(height: 60)
////            .padding(.horizontal)
//            
//            
//            Spacer()
//            Spacer()
//        }
//        .padding()
//    }
//}
//
//#Preview {
//    LoginView()
//        .environmentObject(AuthenticationViewModel())
//}



import SwiftUI
import AuthenticationServices
import Foundation

struct LoginView: View {
    @State private var isLoading = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var isSuccess = false
    
    var body: some View {
        VStack {
            SignInWithAppleButton(.signUp) { request in
                // Request both fullName and email scopes
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
            .disabled(isLoading)
            
            if isLoading {
                ProgressView("Signing in...")
                    .padding()
            }
        }
        .padding()
        .alert(isSuccess ? "Success" : "Error", isPresented: $showAlert) {
            Button("OK") { }
        } message: {
            Text(alertMessage)
        }
    }
    
    private func handleSuccessfulLogin(with authorization: ASAuthorization) {
        guard let userCredential = authorization.credential as? ASAuthorizationAppleIDCredential else {
            showError("Invalid credentials received")
            return
        }
        
        print("User ID: \(userCredential.user)")
        
        // Extract user information
        let userId = userCredential.user
        let firstName = userCredential.fullName?.givenName ?? ""
        let lastName = userCredential.fullName?.familyName ?? ""
        let email = userCredential.email ?? ""
        
        // Create request payload matching your backend's AppleUserRequest structure
        let requestData = AppleUserRequest(
            userId: userId,
            firstName: firstName,
            lastName: lastName,
            email: email
        )
        
        // Send to backend
        sendAppleSignInRequest(requestData)
    }
    
    private func sendAppleSignInRequest(_ userData: AppleUserRequest) {
        isLoading = true
        
        guard let url = URL(string: "https://7906c6ac2a58.ngrok-free.app/api/auth/apple") else {
            showError("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try JSONEncoder().encode(userData)
            request.httpBody = jsonData
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                DispatchQueue.main.async {
                    self.isLoading = false
                    
                    if let error = error {
                        self.showError("Network error: \(error.localizedDescription)")
                        return
                    }
                    
                    guard let httpResponse = response as? HTTPURLResponse else {
                        self.showError("Invalid response")
                        return
                    }
                    
                    if httpResponse.statusCode == 200 {
                        if let data = data {
                            self.handleBackendResponse(data)
                        } else {
                            self.showError("No data received")
                        }
                    } else {
                        if let data = data,
                           let errorMessage = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                           let error = errorMessage["error"] as? String {
                            self.showError("Backend error: \(error)")
                        } else {
                            self.showError("HTTP Error: \(httpResponse.statusCode)")
                        }
                    }
                }
            }.resume()
            
        } catch {
            isLoading = false
            showError("Failed to encode request: \(error.localizedDescription)")
        }
    }
    
    private func handleBackendResponse(_ data: Data) {
        do {
            let response = try JSONDecoder().decode(AppleSignInResponse.self, from: data)
            
            // Store tokens securely (consider using Keychain for production)
            UserDefaults.standard.set(response.accessToken, forKey: "access_token")
            UserDefaults.standard.set(response.refreshToken, forKey: "refresh_token")
            UserDefaults.standard.set(response.refreshTokenExpiryDate, forKey: "refresh_token_expiry")
            
            print("Login successful!")
            print("Message: \(response.message)")
            print("Access Token: \(response.accessToken)")
            print("User Data: \(response.userData)")
            
            showSuccess(response.message)
            
        } catch {
            showError("Failed to decode response: \(error.localizedDescription)")
        }
    }
    
    private func handleLoginError(with error: Error) {
        showError("Apple Sign-In failed: \(error.localizedDescription)")
    }
    
    private func showError(_ message: String) {
        alertMessage = message
        isSuccess = false
        showAlert = true
    }
    
    private func showSuccess(_ message: String) {
        alertMessage = message
        isSuccess = true
        showAlert = true
    }
}

// MARK: - Data Models

struct AppleUserRequest: Codable {
    let userId: String
    let firstName: String
    let lastName: String
    let email: String
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case firstName = "first_name"
        case lastName = "last_name"
        case email
    }
}

struct AppleSignInResponse: Codable {
    let message: String
    let refreshToken: String
    let refreshTokenExpiryDate: String
    let accessToken: String
    let userData: UserData
    
    enum CodingKeys: String, CodingKey {
        case message
        case refreshToken = "refresh_token"
        case refreshTokenExpiryDate = "refresh_token_expiry_date"
        case accessToken = "access_token"
        case userData = "user_data"
    }
}

struct UserData: Codable {
    let id: String
    let firstName: String
    let lastName: String
    let username: String
    let appleEmail: String
    let avatarURL: String
    let balance: Double
    let monthlySavingGoal: Double
    let preferredCurrency: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case username
        case appleEmail = "apple_email"
        case avatarURL = "avatar_url"
        case balance
        case monthlySavingGoal = "monthly_saving_goal"
        case preferredCurrency = "preferred_currency"
    }
}

#Preview {
    LoginView()
}
