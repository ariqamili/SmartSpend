//
//  OnboardQuestionViews.swift
//  SmartSpend
//
//  Created by shortcut mac on 28.8.25.
//

//import SwiftUI
//
//enum OnboardingDataSource {
//    case preferredCurrency
//    case savingGoal
//    case currentBalance
//    
//    var title: String {
//        switch self {
//        case .preferredCurrency:
//            "What is your preferred currency?"
//        case .savingGoal:
//            "What is your saving goal?"
//        case .currentBalance:
//            "What is your balance?"
//        }
//    }
//    
//    var description: String {
//        switch self {
//        case .preferredCurrency:
//            "Please select your preferred currency"
//        case .savingGoal:
//            "Set a goal to stay focused"
//        case .currentBalance:
//            "Set a balance to get started"
//        }
//    }
//    
//    var imageName: String {
//        switch self {
//        case .preferredCurrency:
//            "Currency"
//        case .savingGoal:
//            "SavingGoal"
//        case .currentBalance:
//            "Balance"
//        }
//    }
//    
//    var showBackButton: Bool {
//        switch self {
//        case .preferredCurrency:
//            return false
//        case .currentBalance, .savingGoal:
//            return true
//        }
//    }
//    
//    var showOptionButton: Bool {
//        switch self {
//        case .preferredCurrency:
//            return true
//        case .currentBalance, .savingGoal:
//            return false
//        }
//    }
//    
//    var showTextField: Bool {
//        switch self {
//        case .preferredCurrency:
//            return false
//        case .currentBalance, .savingGoal:
//            return true
//        }
//    }
//    
//    var textFieldPlaceholder: String {
//        switch self {
//        case .savingGoal:
//            return "Enter your saving goal"
//        case .currentBalance:
//            return "Enter your current balance"
//        case .preferredCurrency:
//            return ""
//        
//        }
//    }
//    
//}
//
//
////enum ButtonType{
////    case MKD
////    case EUR
////    case USD
////    
////    var title: String{
////        switch self {
////        case .MKD:
////            return "MKD"
////        case .EUR:
////            return "EUR"
////        case .USD:
////            return "USD"
////        }
////    }
////}
//
//struct OnboardImageView: View {
//    
//    var data: OnboardingDataSource
//    var userResponse: ((String, Bool) -> Void)? = nil
//    var userResponseBack: ((String, Bool) -> Void)? = nil
////    @State private var isCliked: Bool = false
////    @State private var selectedCurrency: ButtonType = .MKD
//    
//    
//    @State private var inputText: String = ""
//    
//    var body: some View {
//        VStack{
//            HStack{
//                Spacer()
//                Button("Skip", action: {
//                    print("Skip")
//                })
//                .foregroundColor(.black)
//                .padding()
//            }
//            Text(data.title)
//                .font(Font.system(size: 49))
//                .fontWeight(.semibold)
//                .padding(.horizontal, 50)
//            
//            Text(data.description)
//                .font(.subheadline)
//                .fontWeight(.semibold)
//                .padding()
//
//            
//            Image(data.imageName)
//                .resizable()
//                .frame(width: 420, height: 290)
//
//            
//            if(data.showTextField) {
//                TextField(data.textFieldPlaceholder, text: $inputText)
//                    .textFieldStyle(RoundedBorderTextFieldStyle())
//                    .padding(.horizontal, 20)
//                    .keyboardType(.decimalPad)
//                
//                
//            } else {
//                HStack(spacing: 20){
//                    Button(action: { print("MKD") }) {
//                        Text("MKD")
//                            .font(.headline)
//                            .foregroundColor(.white)
//                            .frame(maxWidth: .infinity)
//                            .padding()
//                            .background(Color.MainColor)
//                            .cornerRadius(15)
//                    }
//                    .shadow(color: Color.MainColor, radius: 8)
//                
//                    Button(
//                        action: {
//                            print("EUR")
//                            withAnimation(.easeInOut(duration: 0.5)){
////                                selectedCurrency = button
////                                button.isSelected.toggle()
//                            }
//                        }) {
//                            Text("EUR")
//                                .font(.headline)
//                                .foregroundColor(.black)
//                                .frame(maxWidth: .infinity)
//                                .padding()
//                                .background(Color.white)
//                                .cornerRadius(15)
//                        }
//                        
//                
//                Button(
//                    action: {
//                        print("USD")
//                    }) {
//                        Text("USD")
//                            .font(.headline)
//                            .foregroundColor(.black)
//                            .frame(maxWidth: .infinity)
//                            .padding()
//                            .background(Color.white)
//                            .cornerRadius(15)
//                    }
//            }
//                    .padding(.horizontal, 10)
//            }
//            
//            
//            Spacer()
//            
//            HStack(spacing: 180) {
//                if data.showBackButton {
//                    Button(
//                        action: {
////                            printInputFieldText()
//                            userResponseBack?(inputText, true)
//                        }) {
//                        Text("Back")
//                            .font(.headline)
//                            .foregroundColor(.white)
//                            .frame(maxWidth: .infinity)
//                            .padding()
//                            .background(Color.red)
//                            .cornerRadius(15)
//                    }
//                }
//                
//                Button(
//                    action: {
//                        userResponse?(inputText, true)
//                    }) {
//                    Text("Next")
//                        .font(.headline)
//                        .foregroundColor(.white)
//                        .frame(maxWidth: .infinity)
//                        .padding()
//                        .background(Color.MainColor)
//                        .cornerRadius(15)
//                }
//            }
//            .padding(.horizontal, 10)
//            .padding(.vertical, 40)
//            
//            
////            Spacer()
//            
//                
//        }
//    }
//    
//    private func printInputFieldText() {
//        print("Input Text: \(inputText)")
//    }
//}
//
//#Preview {
//    OnboardImageView(data: .preferredCurrency)
//}








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

enum ButtonType: String, CaseIterable, Identifiable {
    case MKD, EUR, USD
    var id: String { rawValue }
    var title: String { rawValue }
}

struct CurrencyButton: View {
    let type: ButtonType
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(type.title)
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
    var data: OnboardingDataSource
    var userResponse: ((String, Bool) -> Void)? = nil
    var userResponseBack: ((String, Bool) -> Void)? = nil
    
    @State private var inputText: String = ""
    @State private var selectedCurrency: ButtonType = .MKD
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button("Skip", action: {
                    print("Skip")
                })
                .foregroundColor(.black)
                .padding(.trailing, 27)
                .padding(.vertical)
            }
            
            Text(data.title)
                .foregroundColor(.black)
                .font(.system(size: 49))
                .fontWeight(.semibold)
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
                    .padding(.horizontal, 20)
                    .keyboardType(.decimalPad)
                    .preferredColorScheme(.light)
            } else {
                HStack(spacing: 16) {
                    ForEach(ButtonType.allCases) { type in
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

struct OnboardImageView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardImageView(data: .preferredCurrency)
    }
}

//            HStack(spacing: 100) {
//                if data.showBackButton {
//                    Button(action: {
//                        userResponseBack?(inputText, true)
//                    }) {
//                        Text("Back")
//                            .font(.headline)
//                            .foregroundColor(.white)
//                            .frame(maxWidth: .infinity)
//                            .padding()
//                            .background(Color.red)
//                            .cornerRadius(15)
//                    }
//                }
//
//                Button(action: {
//                    if data.showTextField {
//                        userResponse?(inputText, true)
//                    } else {
//                        userResponse?(selectedCurrency.title, true)
//                    }
//                }) {
//                    Text("Next")
//                        .font(.headline)
//                        .foregroundColor(.white)
//                        .frame(maxWidth: .infinity)
//                        .padding()
//                        .background(Color.MainColor)
//                        .cornerRadius(15)
//                }
//            }
//            .padding(.horizontal, 10)
//            .padding(.vertical, 40)
