//
//  CategoryViewModel.swift
//  SmartSpend
//
//  Created by Refik Jaija on 28.8.25.
//

import Foundation

@MainActor
class CategoryViewModel: ObservableObject {
    @Published var categories: [Category] = []
    
    @Published var categories2: [Category] = [
        Category(id: UUID(), name: "Groceries"),
        Category(id: UUID(), name: "Rent"),
        Category(id: UUID(), name: "Subscription"),
        Category(id: UUID(), name: "Transportation"),
        Category(id: UUID(), name: "Entertainment"),
        Category(id: UUID(), name: "Utilities"),
        Category(id: UUID(), name: "Healthcare"),
        Category(id: UUID(), name: "Education"),
        Category(id: UUID(), name: "Dining Out"),
        Category(id: UUID(), name: "Clothing"),
        Category(id: UUID(), name: "Investments"),
        Category(id: UUID(), name: "Gifts"),
        Category(id: UUID(), name: "Other")
    ]

    func fetchCategories() async {
        do {
            self.categories = try await APIClient.shared.request(endpoint: "/category")
        } catch {
            print("Failed to fetch categories:", error)
        }
    }
}
