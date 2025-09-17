//
//  ChartBreakdown.swift
//  SmartSpend
//
//  Created by shortcut mac on 17.9.25.
//

import SwiftUI

struct CategoryBreakdown: View {
    @State private var categoryData: [CategorySpending] = [
       CategorySpending(category: "Food", amount: 2500, color: .orange, icon: "fork.knife"),
       CategorySpending(category: "Transport", amount: 1800, color: .blue, icon: "car.fill"),
       CategorySpending(category: "Shopping", amount: 3200, color: .purple, icon: "bag.fill"),
       CategorySpending(category: "Bills", amount: 1200, color: .red, icon: "bolt.fill"),
       CategorySpending(category: "Entertainment", amount: 900, color: .green, icon: "tv.fill"),
       CategorySpending(category: "Health", amount: 600, color: .pink, icon: "heart.fill"),
       CategorySpending(category: "Education", amount: 800, color: .indigo, icon: "book.fill")
   ]
    
    var body: some View {
        ScrollView{
            VStack(alignment: .leading, spacing: 12) {
                Text("Category Breakdown")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .padding(.horizontal)
                
                LazyVStack(spacing: 8) {
                    ForEach(categoryData.sorted(by: { $0.amount > $1.amount })) { item in
                        HStack(spacing: 16) {
                            // Category Icon
                            ZStack {
                                Circle()
                                    .fill(item.color.opacity(0.2))
                                    .frame(width: 40, height: 40)
                                
                                Image(systemName: item.icon)
                                    .foregroundStyle(item.color)
                                    .font(.system(size: 16, weight: .medium))
                            }
                            
                            // Category Info
                            VStack(alignment: .leading, spacing: 2) {
                                Text(item.category)
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                
                                Text("Category spending")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            
                            Spacer()
                            
                            // Amount
                            VStack(alignment: .trailing, spacing: 2) {
                                Text("\(Int(item.amount)) MKD")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                
                                Text("\(Int((item.amount / categoryData.map(\.amount).reduce(0, +)) * 100))%")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(.ultraThinMaterial)
                        )
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

#Preview {
    CategoryBreakdown()
}
