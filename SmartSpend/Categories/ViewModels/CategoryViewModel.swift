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
        Category(id: 1, name: "Groceries"),
        Category(id: 2, name: "Rent"),
        Category(id: 3, name: "Subscription"),
        Category(id: 4, name: "Transportation"),
        Category(id: 5, name: "Entertainment"),
        Category(id: 6, name: "Utilities"),
        Category(id: 7, name: "Healthcare"),
        Category(id: 8, name: "Education"),
        Category(id: 9, name: "Dining Out"),
        Category(id: 10, name: "Clothing"),
        Category(id: 11, name: "Investments"),
        Category(id: 12, name: "Gifts"),
        Category(id: 13, name: "Other")
    ]

    func fetchCategories() async {
        do {
            self.categories = try await APIClient.shared.request(endpoint: "api/category")
        } catch {
            print("Failed to fetch categories:", error)
        }
    }
}
