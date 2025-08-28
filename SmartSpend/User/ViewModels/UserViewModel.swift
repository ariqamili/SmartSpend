//
//  UserViewModel.swift
//  SmartSpend
//
//  Created by Refik Jaija on 28.8.25.
//

import Foundation


@MainActor
class UserViewModel: ObservableObject {
    @Published var currentUser: User?

    func fetchUser() async {
        do {
            self.currentUser = try await APIClient.shared.request(endpoint: "/user")
        } catch {
            print("Failed to fetch user:", error)
        }
    }

    func updateProfile(name: String) async {
        // Call API /user/update
    }
}
