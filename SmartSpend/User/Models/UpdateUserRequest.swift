//
//  UpdateUserRequest.swift
//  SmartSpend
//
//  Created by Refik Jaija on 2.9.25.
//

import Foundation


struct UpdateUserRequest: Encodable {
    var first_name: String?
    var last_name: String?
    var username: String?
    var avatar_url: String?
    var balance: Float?
    var monthly_saving_goal: Float?
    var preferred_currency: User.Currency?
}
