//
//  SmartSpendApp.swift
//  SmartSpend
//
//  Created by shortcut mac on 13.8.25.
//

import SwiftUI
import GoogleSignIn

@main
struct SmartSpendApp: App {
    @StateObject var userVM = UserViewModel()
    @StateObject var authVM = AuthenticationViewModel()
    @StateObject var categoryVM = CategoryViewModel()
    @StateObject var transactionVM = TransactionViewModel()
    
    var body: some Scene {
        WindowGroup {
            Group {
                if authVM.isRestoringSession {
                    ProgressView("Restoring session...") 
                } else if authVM.isSignedIn && userVM.isOnboarded {
                    StartingScreenView(switchingView: ContentView())
<<<<<<< HEAD
                } else if !authVM.isSignedIn{
                    StartingScreenView(switchingView: LoginView())
                }
                else{
                    OnboardView()
                }
                
=======
                } else {
                    StartingScreenView(switchingView: LoginView())
                }
>>>>>>> 03f5016b72bb52e06a0a244c1a4d6964325a7ce1
            }
            .environmentObject(userVM)
            .environmentObject(categoryVM)
            .environmentObject(authVM)
            .environmentObject(transactionVM)
            .onOpenURL { url in
                GIDSignIn.sharedInstance.handle(url)
            }
            .task {
                await authVM.restoreSession(userVM: userVM)
            }
        }
    }
}
