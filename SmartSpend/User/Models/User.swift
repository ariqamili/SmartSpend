//
//  User.swift
//  SmartSpend
//
//  Created by Refik Jaija on 28.8.25.
//

import Foundation

struct User: Codable {
    let first_name: String
    let last_name: String
    let username: String
    let google_email: String?
    let apple_email: String?
    let avatar_url: String?
    
    let balance: Float
    let monthly_saving_goal: Float
    let preferred_currency: Currency
    
    enum Currency: String, CaseIterable, Identifiable, Codable{
        
        case MKD
        case EUR
        case USD
        var id: Self { self }
    }

    
}
