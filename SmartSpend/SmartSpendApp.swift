//
//  SmartSpendApp.swift
//  SmartSpend
//
//  Created by shortcut mac on 13.8.25.
//

import SwiftUI

@main
struct SmartSpendApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}


//import SwiftUI
//
//@main
//struct SmartSpendApp: App {
//    @StateObject private var authCoordinator = AuthCoordinator()
//
//    var body: some Scene {
//        WindowGroup {
//            Group {
//                if authCoordinator.isRestoring {
//                    // while trying to restore, show a loading UI
//                    AuthLoadingView()
//                } else if authCoordinator.isAuthenticated {
//                    DashboardView()
//                } else {
//                    AppleAuthView()
//                }
//            }
//            .environmentObject(authCoordinator)
//            .task {
//                // attempt silent restore on launch
//                await authCoordinator.tryRestoreSession()
//            }
//        }
//    }
//}
