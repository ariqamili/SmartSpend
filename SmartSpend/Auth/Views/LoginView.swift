//
//  LoginView.swift
//  SmartSpend
//
//  Created by Refik Jaija on 17.8.25.
//

import SwiftUI
import GoogleSignInSwift
import AuthenticationServices

struct LoginView: View {
    @EnvironmentObject var authVM: AuthenticationViewModel
    @EnvironmentObject var userVM: UserViewModel

    var isSignedIn: Bool = false
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            Text("Welcome to Smart Spend")
                .font(.system(size: 40))
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundStyle(Color.MainColor)
            Text("Enjoy all the features that make it easy for you to manage your finances, and receive rich insights.")
                .font(.system(size: 15))
                .frame(maxWidth: 350, alignment: .leading)
                .foregroundStyle(.gray)
            
            Spacer()

            // Google Sign In Button
            Button(action: {
                authVM.signIn(userVM: userVM)
            }) {
                HStack {
                    Image("googleLogo")
                        .resizable()
                        .frame(width: 24, height: 24)
                    
                    Text("Continue with Google")
                        .foregroundStyle(.black)
                }
                .frame(maxWidth: .infinity, minHeight: 60)
                .background(Color.white)
                .cornerRadius(12)
                .shadow(radius: 2)
            }
            .padding(.horizontal)
            .disabled(authVM.isLoading)
            
            // Apple Sign In Button
            SignInWithAppleButton(.signUp) { request in
                request.requestedScopes = [.fullName, .email]
            } onCompletion: { result in
                switch result {
                case .success(let authorization):
                    authVM.handleAppleSignIn(with: authorization, userVM: userVM)
                case .failure(let error):
                    authVM.handleAppleSignInError(with: error)
                }
            }
            .frame(height: 60)
            .cornerRadius(12)
            .padding(.horizontal)
            .disabled(authVM.isLoading)
            
            if authVM.isLoading {
                ProgressView("Signing in...")
                    .padding()
            }
            
            Spacer()
            Spacer()
        }
        .padding()
        .alert(authVM.isSuccess ? "Success" : "Error", isPresented: $authVM.showAlert) {
            Button("OK") { }
        } message: {
            Text(authVM.alertMessage)
        }
    }
}

#Preview {
    LoginView()
        .environmentObject(AuthenticationViewModel())
        .environmentObject(UserViewModel())
}
