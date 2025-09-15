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
    var onBoardComplited: Bool = false
    
    var viewModel: OnboardingViewModel = OnboardingViewModel(
        userOnboardingData: .init(
            preferredCurrency: "",
            savingGoal: "",
            currentBalance: ""
        )
    )
    
    var body: some View {
        VStack{
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
            .tabViewStyle(.page(indexDisplayMode: .never))
            .background(Color.sideColor)
            
            HStack (spacing: 12){
                ForEach(0..<3, id: \.self) { index in
                    Circle()
                        .fill(currentPage == index ? Color.MainColor : Color.gray.opacity(0.5))
                        .frame(width: currentPage == index ? 12 : 8, height: currentPage == index ? 12 : 8)
                        .animation(.spring(response: 0.25), value: currentPage)
//                        .animation(.snappy(duration: 0.25, extraBounce: 0.5), value: currentPage)
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
                    //                if data.showTextField {
                    //                    userResponse?(inputText, true)
                    //                } else {
                    //                    userResponse?(selectedCurrency.title, true)
                    //                }
                    withAnimation {
                        currentPage += 1
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
}


#Preview {
    OnboardView(onBoardComplited: false)
}
