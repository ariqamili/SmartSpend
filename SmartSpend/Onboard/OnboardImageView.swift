//
//  OnboardQuestionViews.swift
//  SmartSpend
//
//  Created by shortcut mac on 28.8.25.
//

import SwiftUI

enum OnboardingDataSource {
    case preferredCurrency
    case savingGoal
    case currentBalance
    
    var title: String {
        switch self {
        case .preferredCurrency:
            return "What is your preferred currency?"
        case .savingGoal:
            return "What is your saving goal?"
        case .currentBalance:
            return "What is your balance?"
        }
    }
    
    var description: String {
        switch self {
        case .preferredCurrency:
            return "Please select your preferred currency"
        case .savingGoal:
            return "Set a goal to stay focused"
        case .currentBalance:
            return "Set a balance to get started"
        }
    }
    
    var imageName: String {
        switch self {
        case .preferredCurrency:
            return "Currency"
        case .savingGoal:
            return "SavingGoal"
        case .currentBalance:
            return "Balance"
        }
    }

    var showTextField: Bool {
        switch self {
        case .preferredCurrency:
            return false
        case .currentBalance, .savingGoal:
            return true
        }
    }
    
    var textFieldPlaceholder: String {
        switch self {
        case .savingGoal:
            return "Enter your saving goal"
        case .currentBalance:
            return "Enter your current balance"
        case .preferredCurrency:
            return ""
        }
    }
}

struct CurrencyButton: View {
    let type: User.Currency
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(type.rawValue)
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding()
                .foregroundColor(isSelected ? .white : .black)
                .background(isSelected ? Color.MainColor : Color.white)
                .cornerRadius(15)
                .shadow(color: isSelected ? Color.MainColor.opacity(0.6) : Color.clear,
                        radius: isSelected ? 8 : 0, x: 0, y: isSelected ? 4 : 0)
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.gray.opacity(isSelected ? 0 : 0.25), lineWidth: isSelected ? 0 : 1)
                )
        }
    }
}

struct OnboardImageView: View {
    let data: OnboardingDataSource
    @Binding var inputText: String
    @Binding var selectedCurrency: User.Currency
    var onSkip: () -> Void
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button("Skip", action: onSkip)
                .foregroundColor(.black)
                .padding(.trailing, 27)
                .padding(.vertical)
            }
            
            Text(data.title)
                .foregroundColor(.black)
                .font(.system(size: 49))
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Text(data.description)
                .foregroundColor(.black)
                .font(.subheadline)
                .fontWeight(.semibold)
//                .padding()
            
            Image(data.imageName)
                .resizable()
                .frame(width: 420, height: 280)
            
            if data.showTextField {
                TextField(data.textFieldPlaceholder, text: $inputText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal, 40)
                    .keyboardType(.decimalPad)
                    .preferredColorScheme(.light)
            } else {
                HStack(spacing: 16) {
                    ForEach(User.Currency.allCases) { type in
                        CurrencyButton(type: type, isSelected: selectedCurrency == type) {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                selectedCurrency = type
                            }
                        }
                    }
                }
                .padding(.horizontal, 25)
            }
            
            Spacer()
            
        }
        .frame(maxHeight: .infinity)
    }
}

#Preview{
    OnboardImageView(data: .currentBalance,
                     inputText: .constant(""),
                     selectedCurrency: .constant(.MKD),
                     onSkip: {print("Skip")}
    )
}
