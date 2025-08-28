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
        let category: Category = Category(id: UUID(), name: "Job")
         transactions = [
           Transaction(
               id: UUID(),
               title: "Salary",
               price: 2500,
               dateMade: Date().addingTimeInterval(-86400 * 1), // 1 day ago
               ownerId: UUID(),
               category: category,
               type: .income
               
           ),
           Transaction(
               id: UUID(),
               title: "Bonus",
               price: 500,
               dateMade: Date().addingTimeInterval(-86400 * 1), // 1 day ago
               ownerId: UUID(),
               category: category,
               type: .income
               
           ),
           Transaction(
               id: UUID(),
               title: "Groceries",
               price: 85.50,
               dateMade: Date().addingTimeInterval(-86400 * 2), // 2 days ago
               ownerId: UUID(),
               category: category,
               type: .expense
               
           ),
           Transaction(
               id: UUID(),
               title: "Coffee",
               price: 3.20,
               dateMade: Date().addingTimeInterval(-3600 * 5), // 5 hours ago
               ownerId: UUID(),
               category: category,
               type: .expense
               
           ),
           Transaction(
               id: UUID(),
               title: "Freelance Project",
               price: 600,
               dateMade: Date().addingTimeInterval(-86400 * 3), // 3 days ago
               ownerId: UUID(),
               category: category,
               type: .income
               
           ),
           Transaction(
               id: UUID(),
               title: "Netflix",
               price: 9.99,
               dateMade: Date().addingTimeInterval(-86400 * 4),
               ownerId: UUID(),
               category: category,
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
    
    
    
    
    func addTransaction(title: String, price: Double, dateMade: Date, type: Transaction.TransactionType, ownerId: UUID, category: Category? = nil) async {
        let newTransaction = Transaction(
            id: UUID(),                
            title: title,
            price: price,
            dateMade: dateMade,
            ownerId: ownerId,          // required by backend
            category: category,
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
