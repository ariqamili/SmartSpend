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
            "What is your preferred currency?"
        case .savingGoal:
            "What is your saving goal?"
        case .currentBalance:
            "What is your balance?"
        }
    }
    
    var description: String {
        switch self {
        case .preferredCurrency:
            "Please select your preferred currency"
        case .savingGoal:
            "Set a goal to stay focused"
        case .currentBalance:
            "Set a balance to get started"
        }
    }
    
    var imageName: String {
        switch self {
        case .preferredCurrency:
            "Currency"
        case .savingGoal:
            "SavingGoal"
        case .currentBalance:
            "Balance"
        }
    }
    
    var showBackButton: Bool {
        switch self {
        case .preferredCurrency:
            return false
        case .currentBalance, .savingGoal:
            return true
        }
    }
    
    var showOptionButton: Bool {
        switch self {
        case .preferredCurrency:
            return true
        case .currentBalance, .savingGoal:
            return false
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

struct OnboardImageView: View {
    
    var data: OnboardingDataSource
    var userResponse: ((String, Bool) -> Void)? = nil
    var userResponseBack: ((String, Bool) -> Void)? = nil
    
    @State private var inputText: String = ""
    
    var body: some View {
        VStack{
            HStack{
                Spacer()
                Button("Skip", action: {
                    print("Skip")
                })
                .foregroundColor(.MainColor)
                .padding()
            }
            Text(data.title)
                .font(Font.system(size: 49))
                .fontWeight(.semibold)
                .padding(.horizontal, 50)
            
            Text(data.description)
                .font(.subheadline)
                .fontWeight(.semibold)
                .padding()

            
            Image(data.imageName)
                .resizable()
                .frame(width: 420, height: 290)

            
            if(data.showTextField) {
                TextField(data.textFieldPlaceholder, text: $inputText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal, 20)
                    .keyboardType(.decimalPad)
                
                
            } else {
                HStack(spacing: 20){
                    Button(action: { print("MKD") }) {
                        Text("MKD")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red)
                            .cornerRadius(15)
                    }
                    .shadow(color: Color.red, radius: 15)
                
                    Button(
                        action: {
                            print("EUR")
                        }) {
                            Text("EUR")
                                .font(.headline)
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(15)
                                .border(Color.black, width: 1)
                        }
                        
                
                Button(
                    action: {
                        print("USD")
                    }) {
                        Text("USD")
                            .font(.headline)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.MainColor)
                            .cornerRadius(15)
                    }
            }
                    .padding(.horizontal, 10)
            }
            
            
            Spacer()
            
            HStack(spacing: 180) {
                if data.showBackButton {
                    Button(
                        action: {
//                            printInputFieldText()
                            userResponseBack?(inputText, true)
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
                
                Button(
                    action: {
                        userResponse?(inputText, true)
                    }) {
                    Text("Next")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.MainColor)
                        .cornerRadius(15)
                }
            }
            .padding(.horizontal, 10)
            
            
//            Spacer()
            
                
        }
    }
    
    private func printInputFieldText() {
        print("Input Text: \(inputText)")
    }
}

#Preview {
    OnboardImageView(data: .savingGoal)
}
