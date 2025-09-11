//
//  UpdateTransactionRequest.swift
//  SmartSpend
//
//  Created by Refik Jaija on 11.9.25.
//

import Foundation

struct UpdateTransactionRequest: Encodable {
    var title: String?
    var price: Double?
    var date_made: Date?
    var category_id: Int64?
}
