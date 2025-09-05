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
            ContentView()
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
