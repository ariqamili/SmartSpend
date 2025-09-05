//
//  TransactionViewModel.swift
//  SmartSpend
//
//  Created by Refik Jaija on 26.8.25.
//

import Foundation

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
    
    
    
    
    func fetchTransactions() async {
        do {
            let calendar = Calendar.current
            let today = calendar.startOfDay(for: endDate)
            let start = calendar.startOfDay(for: startDate)

            let formatter = ISO8601DateFormatter()
            formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

            let endpoint = "/transactions?from=\(formatter.string(from: start))&to=\(formatter.string(from: today))"

            let result: [Transaction] = try await APIClient.shared.request(endpoint: endpoint)
            self.transactions = result
        } catch {
            print("Transaction could not be fetched", error)
        }
    }
    
    
    
    func fetchTransactionsNoTime() async{
        do{
            let result: [Transaction] = try await APIClient.shared.request(endpoint: "/transactions")
            
            self.transactions = result
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
                endpoint: "/transactions",
                method: "POST",
                body: newTransaction
            )
            
            await fetchTransactions()
        } catch {
            print("Transaction could not be added:", error)
        }
    }

    
    
}
