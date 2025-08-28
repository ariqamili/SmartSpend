//
//  User.swift
//  SmartSpend
//
//  Created by Refik Jaija on 28.8.25.
//

import Foundation

struct User: Codable, Identifiable {
    let id: UUID
    let firstName: String
    let lastName: String
    let username: String
    let googleEmail: String?
    let appleEmail: String?
    let refreshToken: String?
    let refreshTokenExpiryDate: String?
    let avatarURL: String?
    let createdAt: Date
    
    let categories: [Category]
    let balance: Float
    let monthlySavingGoal: Float
    let preferredCurrency: String
    
    
//    enum CodingKeys: String, CodingKey {
//        case id = "Id"
//        case firstName = "FirstName"
//        case lastName = "LastName"
//        case username = "Username"
//        case googleEmail = "GoogleEmail"
//        case appleEmail = "AppleEmail"
//        case refreshToken = "RefreshToken"
//        case refreshTokenExpiryDate = "RefreshTokenExpiryDate"
//        case avatarURL = "AvatarURL"
//        case createdAt = "CreatedAt"
//        case categories = "Categories"
//        case balance = "Balance"
//        case monthlySavingGoal = "MonthlySavingGoal"
//        case preferredCurrency = "PreferredCurrency"
//    }
}
