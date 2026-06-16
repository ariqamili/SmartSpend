//
//  OnboardView.swift
//  SmartSpend
//
//  Created by shortcut mac on 26.8.25.
//

import SwiftUI


struct OnboardView: View {
    @EnvironmentObject var userVM: UserViewModel
    @State private var selectedCurrency: User.Currency = .MKD
    @State private var currentPage = 0
    @State private var savingGoalText: String = ""
    @State private var balanceText: String = ""
    
    
    var body: some View {
        VStack{
            TabView(selection: $currentPage) {
                OnboardImageView(
                    data: .preferredCurrency,
                    inputText: .constant(""),
                    selectedCurrency: $selectedCurrency,
                    onSkip: skipOnboarding
                )
                .tag(0)
                
                OnboardImageView(
                    data: .savingGoal,
                    inputText: $savingGoalText,
                    selectedCurrency: $selectedCurrency,
                    onSkip: skipOnboarding
                )
                .tag(1)
                
                OnboardImageView(
                    data: .currentBalance,
                    inputText: $balanceText,
                    selectedCurrency: $selectedCurrency,
                    onSkip: skipOnboarding
            )
                .tag(2)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .background(Color.sideColor)
            
            HStack (spacing: 12){
                ForEach(0..<3, id: \.self) { index in
                    Circle()
                        .fill(currentPage == index ? Color.MainColor : Color.gray.opacity(0.5))
                        .frame(width: currentPage == index ? 12 : 8, height: currentPage == index ? 12 : 8)
//                        .animation(.spring(response: 0.25), value: currentPage)
                        .animation(.snappy(duration: 0.25, extraBounce: 0.5), value: currentPage)
                }
            }
            .padding(.top, 10)
            
            HStack(spacing: 100) {
                    if currentPage != 0 {
                Button(action: {
                    withAnimation {
                        currentPage -= 1
                    }
                }) {
                    Text("Back")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(15)
                                    }
                }
                
                Button(action: {
                    if currentPage == 2 {
                        saveOnboardingData()
                    } else {
                        withAnimation {
                            currentPage += 1
                        }
                    }
                }) {
                    Text(currentPage == 2 ? "Finish" : "Next")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.MainColor)
                        .cornerRadius(15)
                }
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 15)
        }
        .background(Color.sideColor)
    }
    
    private func skipOnboarding() {
        let request = UpdateUserRequest(
        balance: Float(savingGoalText) ?? 0,
        monthly_saving_goal: Float(savingGoalText) ?? 0,
        preferred_currency: .MKD
        )
        Task{
            await userVM.updateProfile(request)
            userVM.completeOnboarding()
        }
    }
    
    private func saveOnboardingData() {
        guard let savingGoal = Float(savingGoalText),
              let balance = Float(balanceText) else {
            print("Invalid number format")
            return
        }
        
        let updateRequest = UpdateUserRequest(
            balance: balance, monthly_saving_goal: savingGoal, preferred_currency: selectedCurrency)
        
        Task {
            await userVM.updateProfile(updateRequest)
            await MainActor.run {
                userVM.completeOnboarding()
            }
        }
    }
    
}


#Preview {
    OnboardView()
        .environmentObject(UserViewModel())
}
