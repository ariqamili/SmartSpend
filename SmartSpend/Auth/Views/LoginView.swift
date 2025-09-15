//
//  LoginView.swift
//  SmartSpend
//
//  Created by Refik Jaija on 17.8.25.
//

import SwiftUI
import GoogleSignInSwift

struct LoginView: View {
    @EnvironmentObject var authVM: AuthenticationViewModel
    @EnvironmentObject var userVM: UserViewModel

    var isSignedIn: Bool = false
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            Text("Welcom to Smart Spend")
                .font(.system(size: 40))
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundStyle(Color.MainColor)
            Text("Enjoy all the features that make it easy for you to manage your finances, and receive rich insights.")
                .font(.system(size: 15))
                .frame(maxWidth: 350, alignment: .leading)
                .foregroundStyle(.gray)
            
            Spacer()

//            GoogleSignInButton(action: authVM.signIn)
//                .frame(height: 50)
//                .padding()
  
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
            
            Spacer()
            Spacer()

        
        }
        .padding()
    }
}

#Preview {
    LoginView()
        .environmentObject(AuthenticationViewModel())
        .environmentObject(UserViewModel()) 
}
