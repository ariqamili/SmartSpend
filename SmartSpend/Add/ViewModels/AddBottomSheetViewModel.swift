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
    
    private let transactionVM: TransactionViewModel
    private let userVM: UserViewModel
    private var categoryVM: CategoryViewModel
    
    init(transactionVM: TransactionViewModel, userVM: UserViewModel, categoryVM: CategoryViewModel) {
        self.transactionVM = transactionVM
        self.userVM = userVM
        self.categoryVM = categoryVM
    }
    
    @Published var selected: Int = 1
    
    
    @Published var expenseTitle: String = ""
    @Published var expenseCategory: Int64 = 1
    @Published var expensePrice: String = ""
    var expensePriceBool: Double {
        Double(expensePrice) ?? 0.0
    }
    @Published var expenseDate: Date = Date()
    
    
    
    @Published var incomeTitle: String = ""
    @Published var incomeCategory: Category = .init(id: 2, name: "")
    @Published var incomePrice: String = ""
    var incomePriceBool: Double {
        Double(expensePrice) ?? 0.0
    }
    @Published var incomeDate: Date = Date()
        
    
    
    func AddExpense() async {

        await transactionVM.addTransaction(title: expenseTitle, price: expensePriceBool, date_made: expenseDate, type: .expense, category_id: expenseCategory)
    }
    
    func AddIncome() async {

        await transactionVM.addTransaction(title: incomeTitle, price: incomePriceBool, date_made: incomeDate, type: .income, category_id: nil)
    }

 
    
}
