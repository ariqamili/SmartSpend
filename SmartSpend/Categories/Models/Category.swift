//
//  Category.swift
//  SmartSpend
//
//  Created by Refik Jaija on 27.8.25.
//

import Foundation

struct Category: Identifiable, Codable, Hashable {
    let id: UUID
    let name: String

//    enum CodingKeys: String, CodingKey {
//        case id = "Id"
//        case name = "Name"
//    }
}
