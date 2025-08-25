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
            Text("SmartSpend")
                .font(.largeTitle)
                .bold()

            if vm.isLoading {
                ProgressView("Signing in...")
            }

            // Use the custom sign in button that properly integrates with your service
            Button(action: {
                vm.signIn()
            }) {
                HStack {
                    Image(systemName: "apple.logo")
                        .foregroundColor(.white)
                    Text("Sign in with Apple")
                        .foregroundColor(.white)
                        .fontWeight(.medium)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 44)
                .background(Color.black)
                .cornerRadius(8)
            }
            .disabled(vm.isLoading)
            .padding(.horizontal, 24)

            if let err = vm.errorMessage {
                Text(err)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }

            if vm.isAuthenticated {
                VStack(spacing: 8) {
                    Text("Signed in")
                        .foregroundColor(.green)
                        .bold()
                    
                    if !vm.firstName.isEmpty || !vm.email.isEmpty {
                        Text("\(vm.firstName) — \(vm.email)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    Button("Sign out") {
                        vm.signOut()
                    }
                    .buttonStyle(.bordered)
                    .padding(.top, 8)
                }
            }
        }
        .padding()
    }
}
