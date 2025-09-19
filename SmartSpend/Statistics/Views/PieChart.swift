//
//  PieChart.swift
//  SmartSpend
//
//  Created by shortcut mac on 12.9.25.
//

import SwiftUI
import Charts

struct CategorySpending: Identifiable {
    let id = UUID()
    let category: String
    let amount: Double
    let color: Color
    let icon: String
}


struct PieChart: View {
    
    @State private var categoryData: [CategorySpending] = [
       CategorySpending(category: "Food", amount: 2500, color: .orange, icon: "fork.knife"),
       CategorySpending(category: "Transport", amount: 1800, color: .blue, icon: "car.fill"),
       CategorySpending(category: "Shopping", amount: 3200, color: .purple, icon: "bag.fill"),
       CategorySpending(category: "Bills", amount: 1200, color: .red, icon: "bolt.fill"),
       CategorySpending(category: "Entertainment", amount: 900, color: .green, icon: "tv.fill"),
       CategorySpending(category: "Health", amount: 600, color: .pink, icon: "heart.fill"),
       CategorySpending(category: "Education", amount: 800, color: .indigo, icon: "book.fill")
   ]
    
    var isOnHomeView: Bool
    
    var body: some View {
        VStack(spacing: 12) {
            if isOnHomeView {
                HStack {
                    Spacer()
                    NavigationLink("View More") {
                        StatsView()
                    }
                    .font(.footnote)
                    .foregroundColor(.MainColor)
                    .padding(.horizontal)
                    .padding(.top)
                }
                .padding(.horizontal)
            }
            
            Chart(categoryData) { item in
                SectorMark(angle: .value("Category", item.amount), angularInset: 2)
                    .foregroundStyle(by: .value("category", item.category))
                    .cornerRadius(5)
                    .annotation(position: .overlay) {
                        Text(item.category)
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.white)
                            .shadow(color: .black.opacity(0.5), radius: 1, x: 0, y: 1)
                    }
            }
            .chartLegend(.hidden)
            .frame(height: 320)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.MainColor.opacity(0.2))
                //                .stroke(Color.MainColor, lineWidth: 1)
                    .padding(.horizontal)
                
            )
            .frame(maxWidth: .infinity)
            
            CategoryBreakdown()
        }
    }
}

#Preview {
    NavigationStack {
        PieChart(isOnHomeView: false)
    }
}
