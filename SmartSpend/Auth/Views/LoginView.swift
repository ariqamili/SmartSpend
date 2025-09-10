////
////  LoginView.swift
////  SmartSpend
////
////  Created by Refik Jaija on 17.8.25.
////
//
//import SwiftUI
//import GoogleSignInSwift
//
//struct LoginView: View {
//    @EnvironmentObject var authVM: AuthenticationViewModel
//
//
//    var body: some View {
//        VStack(spacing: 20) {
//            Spacer()
//            Text("Welcom to Smart Spend")
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
////            GoogleSignInButton(action: authVM.signIn)
////                .frame(height: 50)
////                .padding()
//  
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
//            Spacer()
//            Spacer()
//
//        
//        }
//        .padding()
//    }
//}
//
//#Preview {
//    LoginView()
//        .environmentObject(AuthenticationViewModel()) 
//}



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

            // Google Sign In Button (existing)
            Button(action: {
                authVM.signIn()
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
            
            // Apple Sign In Button (NEW)
            Button(action: {
                authVM.signInWithApple()
            }) {
                HStack {
                    Image(systemName: "apple.logo")
                        .font(.system(size: 24))
                        .foregroundStyle(.white)
                    
                    Text("Continue with Apple")
                        .foregroundStyle(.white)
                }
                .frame(maxWidth: .infinity, minHeight: 60)
                .background(Color.black)
                .cornerRadius(12)
            }
            .padding(.horizontal)
            
            // Alternative: Native Apple Sign In Button (you can use this instead if preferred)
            
//            SignInWithAppleButton(.signIn) { request in
//                request.requestedScopes = [.fullName, .email]
//            } onCompletion: { result in
//                switch result {
//                case .success(let authorization):
//                    // Handle in AuthenticationViewModel
//                    print(result)
//                    break
//                case .failure(let error):
//                    print("Apple Sign In error: \(error)")
//                }
//            }
//            .signInWithAppleButtonStyle(.black)
//            .frame(height: 60)
//            .padding(.horizontal)
            
            
            Spacer()
            Spacer()
        }
        .padding()
    }
}

#Preview {
    LoginView()
        .environmentObject(AuthenticationViewModel())
}
