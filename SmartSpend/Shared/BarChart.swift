//
//  BarChart.swift
//  SmartSpend
//
//  Created by shortcut mac on 12.9.25.
//

import SwiftUI
import Charts

struct BarChart: View {
    
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
            VStack{
                Chart(categoryData) { item in
                    BarMark(
                        x: .value("Category", item.category),
                        y: .value("Amount", item.amount)
                    )
                    .foregroundStyle(
                        LinearGradient(
                            colors: [item.color.opacity(0.8), item.color.opacity(0.4)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .cornerRadius(8)
                }
                .frame(height: 250)
                .chartXAxis {
                    AxisMarks(values: .automatic) { value in
                        AxisGridLine(stroke: StrokeStyle(lineWidth: 0.5, dash: [2, 2]))
                            .foregroundStyle(.gray.opacity(0.3))
                        AxisTick(stroke: StrokeStyle(lineWidth: 0))
                        AxisValueLabel() {
                            if let category = value.as(String.self) {
                                VStack(spacing: 4) {
                                    if let categoryItem = categoryData.first(where: { $0.category == category }) {
                                        Image(systemName: categoryItem.icon)
                                            .foregroundStyle(categoryItem.color)
                                            .font(.caption)
                                    }
                                    Text(category)
                                        .font(.caption2)
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                    }
                }
                .chartYAxis {
                    AxisMarks(values: .automatic) { value in
                        AxisGridLine(stroke: StrokeStyle(lineWidth: 0.5, dash: [2, 2]))
                            .foregroundStyle(.gray.opacity(0.3))
                        AxisTick(stroke: StrokeStyle(lineWidth: 0))
                        AxisValueLabel() {
                            if let amount = value.as(Double.self) {
                                Text("\(Int(amount/1000))k")
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
                //            .chartAngleSelection(value: .constant(nil))
                .padding(.horizontal)
                .padding(.top)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.ultraThinMaterial)
                        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
                )
                .padding(.horizontal)
                
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
}

#Preview {
    BarChart()
}
