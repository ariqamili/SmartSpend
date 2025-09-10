//
//  OnboardView.swift
//  SmartSpend
//
//  Created by shortcut mac on 26.8.25.
//

import SwiftUI

struct OnboardingData {
    var preferredCurrency: String
    var savingGoal: String
    var currentBalance: String
    
    mutating func updatePreferredCurrency(_ newValue: String) {
         preferredCurrency = newValue
    }
    
    mutating func updateSavingGoal(_ newValue: String) {
        self.savingGoal = newValue
    }
    
    mutating func updateCurrentBalance(_ newValue: String) {
        self.currentBalance = newValue
    }
}

class OnboardingViewModel {
    var userOnboardingData: OnboardingData
    
    init(userOnboardingData: OnboardingData) {
        self.userOnboardingData = userOnboardingData
    }
    
    func updatePreferredCurrency(_ newValue: String) {
        userOnboardingData.updatePreferredCurrency(newValue)
    }
    
//    TODO + optimizim
        func updateSavingGoal(_ newValue: String) {
            userOnboardingData.updateSavingGoal(newValue)
    }
    
    func updateCurrentBalance(_ newValue: String) {
        userOnboardingData.updateCurrentBalance(newValue)
    }
}

struct OnboardView: View {
    
    
    @State var isOnboarded: Bool = false
    
    @State private var currentPage = 0
    
    var viewModel: OnboardingViewModel = OnboardingViewModel(
        userOnboardingData: .init(
            preferredCurrency: "",
            savingGoal: "",
            currentBalance: ""
        )
    )
    
    var body: some View {
        TabView(selection: $currentPage) {
            OnboardImageView(
                data: .preferredCurrency,
                userResponse: { input, _ in
                    viewModel.updatePreferredCurrency(input)
                    print(input)
                    withAnimation {
                        currentPage += 1
                    }
            })
            .tag(0)
            
            OnboardImageView(
                data: .savingGoal,
                userResponse: { input, _ in
                    viewModel.updateSavingGoal(input)
                    print(input)
                    withAnimation {
                        currentPage += 1
                    }
            },
            userResponseBack: { input, _ in
                viewModel.updateSavingGoal(input)
                print(input)
                withAnimation {
                    currentPage -= 1
                }
                }
            )
            .tag(1)
            
            OnboardImageView(
                data: .currentBalance,
                userResponse: { input, _ in
                    viewModel.updateCurrentBalance(input)
                    print(input)
                withAnimation {
                    currentPage += 1
                }
            },
                userResponseBack: { input, _ in
                    viewModel.updateCurrentBalance(input)
                    print(input)
                    withAnimation {
                        currentPage -= 1
                    }
                    })
            .tag(2)
        }
        .tabViewStyle(.page(indexDisplayMode: .always))
        .indexViewStyle(.page(backgroundDisplayMode: .always))
        .background(Color.sideColor)
    }
}


#Preview {
    OnboardView()
}
