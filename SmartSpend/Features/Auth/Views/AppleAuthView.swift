//
//  AppleAuthView.swift
//  SmartSpend
//
//  Created by shortcut mac on 17.8.25.
//



import SwiftUI
import AuthenticationServices

struct AppleAuthView: View {
    @StateObject private var vm = AppleAuthViewModel()

    var body: some View {
        VStack(spacing: 18) {
            Text("SmartSpend").font(.largeTitle).bold()

            if vm.isLoading { ProgressView() }

            SignInWithAppleButton(.signIn) { request in
                request.requestedScopes = [.email, .fullName]
                // set hashed nonce (ViewModel returns hashed value)
                request.nonce = vm.prepareNonceForRequest()
            } onCompletion: { result in
                vm.handleAuthorizationResult(result)
            }
            .frame(height: 44)
            .signInWithAppleButtonStyle(.black)
            .padding(.horizontal, 24)

            if let err = vm.errorMessage {
                Text(err).foregroundColor(.red).multilineTextAlignment(.center).padding(.horizontal)
            }

            if vm.isAuthenticated {
                Text("Signed in").foregroundColor(.green).bold()
            }
        }
        .padding()
    }
}



//import SwiftUI
//import AuthenticationServices
//
//struct AppleAuthView: View {
//    @StateObject private var vm = AppleAuthViewModel()
//
//    var body: some View {
//        VStack(spacing: 18) {
//            Text("SmartSpend")
//                .font(.largeTitle)
//                .bold()
//
//            if vm.isLoading { ProgressView() }
//
//            SignInWithAppleButton(.signIn) { request in
//                request.requestedScopes = [.email, .fullName]
//                // nonce handled by AppleAuthService.signIn()
//            } onCompletion: { _ in }
//            .onTapGesture { vm.signIn() }
//            .frame(height: 44)
//            .signInWithAppleButtonStyle(.black)
//            .padding(.horizontal, 24)
//
//            if let err = vm.errorMessage {
//                Text(err).foregroundColor(.red).multilineTextAlignment(.center).padding(.horizontal)
//            }
//
//            if vm.isAuthenticated {
//                VStack(spacing: 8) {
//                    Text("Signed in").foregroundColor(.green).bold()
//                    if !vm.firstName.isEmpty || !vm.email.isEmpty {
//                        Text("\(vm.firstName) — \(vm.email)").font(.subheadline).foregroundColor(.secondary)
//                    }
//                    Button("Sign out") { vm.signOut() }.buttonStyle(.bordered).padding(.top, 8)
//                }
//            }
//        }
//        .padding()
//    }
//}
