//
//  UserViewModel.swift
//  SmartSpend
//
//  Created by Refik Jaija on 28.8.25.
//

import Foundation

//enum Enpoints1 {
//    case user
//
//    var getPath: String {
//        switch self {
//        case .user:
//            "user/me"
//        }
//    }
//}


@MainActor
class UserViewModel: ObservableObject {
    @Published var currentUser: User?
    @Published var isOnboarded = false

    private let onboardingKey = "hasCompletedOnboarding"
    
    init() {
            loadOnboardingStatus()
        }
   
    func fetchUser() async {
        do {
            let response: UserResponse = try await APIClient.shared.request(endpoint: "api/user/me")
            self.currentUser = response.data
        } catch {
            print("Failed to fetch user:", error)
        }
    }

    
    func updateProfile(_ request: UpdateUserRequest) async {
        
        struct UpdateUserResponse: Decodable {
            let message: String
        }
        
        do {
            let response: UserResponse = try await APIClient.shared.request(
                endpoint: "api/user/update",
                method: "PATCH",
                body: request
            )
//            print(response.message)

            await fetchUser()
            
            currentUser = response.data
            print("User updated successfully:", response.data)

        } catch {
            print("Failed to update user:", error)
        }
    }
    
    func completeOnboarding() {
//        DispatchQueue.main.async {
//            self.isOnboarded = true
//        }
        
        isOnboarded = true
                // Persist this state so user doesn't see onboarding again
                UserDefaults.standard.set(true, forKey: onboardingKey)
                print("Onboarding completed and saved to UserDefaults")
    }
    
    private func loadOnboardingStatus() {
            isOnboarded = UserDefaults.standard.bool(forKey: onboardingKey)
            print("Loaded onboarding status: \(isOnboarded)")
        }
    
    func resetOnboardingStatus() {
            // For testing purposes or if user wants to redo onboarding
            isOnboarded = false
            UserDefaults.standard.removeObject(forKey: onboardingKey)
            print("Onboarding status reset")
        }
    
}
