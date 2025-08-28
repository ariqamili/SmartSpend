//
//  AddBottomSheetViewModel.swift
//  SmartSpend
//
//  Created by Refik Jaija on 25.8.25.
//

import Foundation
import SwiftUICore



@MainActor
class AddBottomSheetViewModel: ObservableObject {
    @Published var selected: Int = 1
    
    @StateObject private var viewModelTransaction = TransactionViewModel()
    @StateObject private var viewModelUser = UserViewModel()
    
    
    
    @Published var expenseTitle: String = ""
    @Published var expenseCategory: Category = .init(id: UUID(), name: "")
    @Published var expensePrice: String = ""
    var expensePriceBool: Double {
        Double(expensePrice) ?? 0.0
    }
    @Published var expenseDate: Date = Date()
    
    
    
    @Published var incomeTitle: String = ""
    @Published var incomeCategory: Category = .init(id: UUID(), name: "")
    @Published var incomePrice: String = ""
    var incomePriceBool: Double {
        Double(expensePrice) ?? 0.0
    }
    @Published var incomeDate: Date = Date()
        
    
    
    func AddExpense() async {
        guard let user = viewModelUser.currentUser else {
            print("No user logged in")
            return
        }
        await viewModelTransaction.addTransaction(title: expenseTitle, price: expensePriceBool, dateMade: expenseDate, type: .expense, ownerId: user.id, category: expenseCategory)
    }
    
    func AddIncome() async {
        guard let user = viewModelUser.currentUser else {
            print("No user logged in")
            return
        }
        await viewModelTransaction.addTransaction(title: incomeTitle, price: incomePriceBool, dateMade: incomeDate, type: .income, ownerId: user.id, category: nil)
    }

 
    
}
