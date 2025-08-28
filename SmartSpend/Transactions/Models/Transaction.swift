//
//  Transaction.swift
//  SmartSpend
//
//  Created by Refik Jaija on 26.8.25.
//

import Foundation

//struct Transaction: Identifiable, Codable {
//    let id: UUID
//    let title: String
//    let amount: Double
//    let date: Date
//    let type: TransactionType
//    let category: String? // optional for expenses
//
//    enum TransactionType: String, Codable {
//        case income
//        case expense
//    }
//
//}

struct Transaction: Identifiable, Codable {
    let id: UUID
    let title: String
    let price: Double
    let dateMade: Date
    let ownerId: UUID
    let category: Category?
    let type: TransactionType

    enum TransactionType: String, Codable {
        case expense = "Expense"
        case income = "Income"
    }

//    enum CodingKeys: String, CodingKey {
//        case id = "Id"
//        case title = "Title"
//        case price = "Price"
//        case dateMade = "DateMade"
//        case ownerId = "Owner"
//        case category = "Category"
//        case type = "Type"
//    }
}



extension Array where Element == Transaction {
    func groupedByDay() -> [Date: [Transaction]] {
        Dictionary(grouping: self) { transaction in
            Calendar.current.startOfDay(for: transaction.dateMade)
        }
    }
}
