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
                } else {
                    StartingScreenView(switchingView: LoginView())
                }
                
                if authVM.isSignedIn && userVM.isOnboarded {
                    StartingScreenView(switchingView: ContentView())
                } else if !authVM.isSignedIn{
                    StartingScreenView(switchingView: LoginView())
                }
                else{
                    OnboardView()
                }
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
        
        //        Group {
        //            if authVM.isSignedIn && userVM.isOnboarded {
        //                StartingScreenView(switchingView: mainTabView)
        //            } else if !authVM.isSignedIn{
        //                StartingScreenView(switchingView: LoginView())
        //            }
        //            else{
        //                OnboardView()
        //            }
        //
        //        }
        //        .onChange(of: authVM.isSignedIn) { oldValue, newValue in
        //            if newValue {
        //                Task {
        //                    await userVM.fetchUser()
        //                    print("The current user: \(String(describing: userVM.currentUser))")
        //                   // await categoryVM.fetchCategories()
        //                }
        //            } else {
        //                // Clear cached user on sign out
        //                userVM.currentUser = nil
        //            }
        //
        //        }
    }
}
