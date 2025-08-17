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

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authVM)
                .onOpenURL { url in
                    GIDSignIn.sharedInstance.handle(url)
                }
        }
    }
}
