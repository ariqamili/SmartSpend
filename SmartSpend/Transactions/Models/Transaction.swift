//
//  Transaction.swift
//  SmartSpend
//
//  Created by Refik Jaija on 26.8.25.
//

import Foundation

struct Transaction: Identifiable, Codable {
    let id: Int64?
    let title: String
    let price: Double
    let date_made: Date
    let category_id: Int64?
    let type: TransactionType

    enum TransactionType: String, Codable {
        case expense = "Expense"
        case income = "Income"
    }


}



extension Array where Element == Transaction {
    func groupedByDay() -> [Date: [Transaction]] {
        Dictionary(grouping: self) { transaction in
            Calendar.current.startOfDay(for: transaction.date_made)
        }
    }
}
