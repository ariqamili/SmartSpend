//
//  AddBottomSheetViewModel.swift
//  SmartSpend
//
//  Created by Refik Jaija on 25.8.25.
//

import Foundation
import SwiftUI
import UIKit



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
        Double(incomePrice) ?? 0.0
    }
    @Published var incomeDate: Date = Date()
    
    @Published var isAnalyzingReceipt: Bool = false
        
    
    
    func analyzeReceipt(receiptImage: UIImage) async {
        isAnalyzingReceipt = true
        defer { isAnalyzingReceipt = false }  // always turn off when done
        
        if let draft = await transactionVM.draftTransactionFromReceipt(image: receiptImage) {
            expenseTitle = draft.title
            expensePrice = String(draft.price)
            expenseDate = draft.date_made
            expenseCategory = draft.category_id ?? expenseCategory
        }
    }
    
    
    
    func AddExpense() async -> Bool{

        await transactionVM.addTransaction(title: expenseTitle, price: expensePriceBool, date_made: expenseDate, type: .expense, category_id: expenseCategory)
        await userVM.fetchUser()
        
        return true
    }
    
    func AddIncome() async -> Bool{

        await transactionVM.addTransaction(title: incomeTitle, price: incomePriceBool, date_made: incomeDate, type: .income, category_id: nil)
        await userVM.fetchUser()
        
        return true
    }

 
    
}
