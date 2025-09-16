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
    
    var expenses: Int {
        transactions.count(where: { $0.type == .expense })
    }
    
    var income: Int {
        transactions.count(where: { $0.type == .income })
    }
    
    init() {
        loadFakeData()
    }
    
    func loadFakeData(){
         transactions = [
           Transaction(
               id: 1,
               title: "Salary",
               price: 2500,
               date_made: Date().addingTimeInterval(-86400 * 1), // 1 day ago
               category_id: 1,
               type: .income
               
           ),
           Transaction(
               id: 2,
               title: "Bonus",
               price: 500,
               date_made: Date().addingTimeInterval(-86400 * 1), // 1 day ago
               category_id: 2,
               type: .income
               
           ),
           Transaction(
               id: 3,
               title: "Groceries",
               price: 85.50,
               date_made: Date().addingTimeInterval(-86400 * 2), // 2 days ago
               category_id: 3,
               type: .expense
               
           ),
           Transaction(
               id: 4,
               title: "Coffee",
               price: 3.20,
               date_made: Date().addingTimeInterval(-3600 * 5), // 5 hours ago
               category_id: 4,
               type: .expense
               
           ),
           Transaction(
               id: 5,
               title: "Freelance Project",
               price: 600,
               date_made: Date().addingTimeInterval(-86400 * 3), // 3 days ago
               category_id: 5,
               type: .income
               
           ),
           Transaction(
               id: 6,
               title: "Netflix",
               price: 9.99,
               date_made: Date().addingTimeInterval(-86400 * 4),
               category_id: 6,
               type: .expense
               
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
    
    
    
    
    func addTransaction(title: String, price: Double, date_made: Date, type: Transaction.TransactionType, category_id: Int64? = nil) async {
        let newTransaction = Transaction(
            id: nil,
            title: title,
            price: price,
            date_made: date_made,
            category_id: category_id,
            type: type
        )
        
        do {
            let _: Transaction = try await APIClient.shared.request(
                endpoint: "api/transaction",
                method: "POST",
                body: newTransaction
            )
            
            await fetchTransactionsNoTime()
        } catch {
            print("Transaction could not be added:", error)
        }
    }
    
    
    func addTransactionWithReceipt(
        title: String,
        price: Double,
        date_made: Date,
        type: Transaction.TransactionType,
        category_id: Int64? = nil,
        receiptImage: UIImage
    ) async {
        do {
            let formatter = ISO8601DateFormatter()
            formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

            var params: [String: String] = [
                "title": title,
                "price": String(price),
                "date_made": formatter.string(from: date_made),
                "type": type.rawValue
            ]
            
            if let category_id = category_id {
                params["category_id"] = String(category_id)
            }
            
            let _: Transaction = try await APIClient.shared.uploadMultipart(
                endpoint: "api/transaction/receipt",
                image: receiptImage,
                imageFieldName: "image", // make sure this matches backend!
                parameters: params
            )
            
            await fetchTransactionsNoTime()
        } catch {
            print("Transaction with receipt could not be added:", error)
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
