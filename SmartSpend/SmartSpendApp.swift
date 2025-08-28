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
    @StateObject var authVM = AuthenticationViewModel()
    @StateObject var userVM = UserViewModel()
    @StateObject var categoryVM = CategoryViewModel()
    

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(userVM)
                .environmentObject(categoryVM)
                .environmentObject(authVM)
                .onOpenURL { url in
                    GIDSignIn.sharedInstance.handle(url)
                }
        }
    }
}
