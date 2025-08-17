//
//  AuthCoordinator.swift
//  SmartSpend
//
//  Created by shortcut mac on 17.8.25.
//

import Foundation
import SwiftUI

/// Small coordinator skeleton to centralize auth navigation (optional)
final class AuthCoordinator: ObservableObject {
    @Published var isAuthenticated: Bool = false

    func didSignIn() {
        isAuthenticated = true
    }

    func signOut() {
        isAuthenticated = false
    }
}
