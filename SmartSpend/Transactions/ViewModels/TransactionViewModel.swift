//
//  TransactionViewModel.swift
//  SmartSpend
//
//  Created by Refik Jaija on 26.8.25.
//

import Foundation
import UIKit

@MainActor
class TransactionViewModel: ObservableObject{
    
    @Published var transactions: [Transaction] =  []
    
    @Published var startDate: Date = {
        let calendar = Calendar.current
        let today = Date()
        // Get the first day of the current month
        let components = calendar.dateComponents([.year, .month], from: today)
        return calendar.date(from: components) ?? today
    }()
    
    @Published var endDate: Date = Date()
    
    var expenses: Double {
        transactions
            .filter { $0.type == .expense }
            .reduce(0) { $0 + $1.price }
    }
    
    var income: Double {
        transactions
            .filter { $0.type == .income }
            .reduce(0) { $0 + $1.price }
    }
    
    var netBalance: Double {
        income - expenses
    }
    
    init() {
        loadFakeData()
    }
    
    func loadFakeData(){
        let calendar = Calendar.current
        
        transactions = [
            Transaction(
                id: 1,
                title: "Salary",
                price: 2500,
                date_made: calendar.date(from: DateComponents(year: 2025, month: 1, day: 10))!, // January
                category_id: 1,
                type: .income
            ),
            Transaction(
                id: 2,
                title: "Bonus",
                price: 500,
                date_made: calendar.date(from: DateComponents(year: 2025, month: 2, day: 15))!, // February
                category_id: 2,
                type: .income
            ),
            Transaction(
                id: 3,
                title: "Groceries",
                price: 85.50,
                date_made: calendar.date(from: DateComponents(year: 2025, month: 2, day: 20))!, // February
                category_id: 3,
                type: .expense
            ),
            Transaction(
                id: 4,
                title: "Coffee",
                price: 3.20,
                date_made: calendar.date(from: DateComponents(year: 2025, month: 3, day: 5))!, // March
                category_id: 4,
                type: .expense
            ),
            Transaction(
                id: 5,
                title: "Freelance Project",
                price: 600,
                date_made: calendar.date(from: DateComponents(year: 2025, month: 9, day: 17))!, // September
                category_id: 5,
                type: .income
            )
        ]
    }

    
    struct ResponseTransaction: Codable{
       var data: [Transaction]
    }
    
    
    func fetchTransactions() async {
        do {
            let calendar = Calendar.current
            let start = calendar.startOfDay(for: startDate)

            let startOfNextDay = calendar.date(byAdding: .day, value: 1, to: calendar.startOfDay(for: endDate))!
            let end = startOfNextDay.addingTimeInterval(-0.001)

            let formatter = ISO8601DateFormatter()
            formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

            let endpoint = "api/transaction?from=\(formatter.string(from: start))&to=\(formatter.string(from: end))"

            let result: ResponseTransaction = try await APIClient.shared.request(endpoint: endpoint)
            self.transactions = result.data
        } catch {
            print("Transaction could not be fetched", error)
        }
    }

    
    
    
    func fetchTransactionsNoTime() async{
        do{
            let endpoint = "api/transaction"
            let result: ResponseTransaction = try await APIClient.shared.request(endpoint: endpoint)

            self.transactions = result.data
            
        }
        catch{
            
            print("Transaction could not be fetched", error)
        }
    }
    
    
    struct MessageResponse: Codable {
        let message: String
    }

    
    
    func addTransaction(title: String, price: Double, date_made: Date, type: Transaction.TransactionType, category_id: Int64? = nil) async -> Bool {
        let newTransaction = Transaction(
            id: nil,
            title: title,
            price: price,
            date_made: date_made,
            category_id: category_id,
            type: type
        )
        
        do {
            let response: MessageResponse = try await APIClient.shared.request(
                endpoint: "api/transaction",
                method: "POST",
                body: newTransaction
            )
            print("Added transaction:", response.message)
            return true
        } catch {
            print("Transaction could not be added:", error)
            return false
        }
    }
    

    func draftTransactionFromReceipt(image: UIImage) async -> Transaction? {
           do {
               let transaction: Transaction = try await APIClient.shared.uploadMultipart(
                   endpoint: "api/transaction/receipt",
                   image: image,
                   imageFieldName: "image",
                   parameters: [:]
               )
               return transaction
           } catch {
               print("Receipt upload failed:", error)
               return nil
           }
       }
    
    
    
    func editTransaction(
        id: Int64,
        title: String? = nil,
        price: Double? = nil,
        date_made: Date? = nil,
        category_id: Int64? = nil
    ) async {
        let request = UpdateTransactionRequest(
            title: title,
            price: price,
            date_made: date_made,
            category_id: category_id
        )
        
        do {
            let _: Transaction = try await APIClient.shared.request(
                endpoint: "api/transaction/\(id)",
                method: "PATCH",
                body: request
            )
            
        } catch {
            print("Transaction could not be edited:", error)
        }
    }
    
    
    func deleteTransaction(id: Int64) async {
        
        do {
            let _: Transaction = try await APIClient.shared.request(
                endpoint: "api/transaction/\(id)",
                method: "DELETE"
            )
            
        } catch {
            print("Transaction could not be edited:", error)
        }
    }



    
    
}



extension TransactionViewModel {
    struct MonthlyBalance: Identifiable {
        let id = UUID()
        let date: Date
        let balance: Double
    }
    
    var monthlyBalances: [MonthlyBalance] {
        let calendar = Calendar.current
        
        // group all transactions by year+month
        let grouped = Dictionary(grouping: transactions) { transaction in
            let comps = calendar.dateComponents([.year, .month], from: transaction.date_made)
            return comps
        }
        
        // calculate balance per group
        return grouped.compactMap { comps, txs in
            guard let year = comps.year, let month = comps.month else { return nil }
            let firstOfMonth = calendar.date(from: DateComponents(year: year, month: month))!
            
            let income = txs.filter { $0.type == .income }.reduce(0) { $0 + $1.price }
            let expenses = txs.filter { $0.type == .expense }.reduce(0) { $0 + $1.price }
            
            return MonthlyBalance(date: firstOfMonth, balance: income - expenses)
        }
        // sort by month
        .sorted { $0.date < $1.date }
    }
}

