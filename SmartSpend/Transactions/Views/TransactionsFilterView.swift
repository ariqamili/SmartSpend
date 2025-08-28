//
//  TransactionsFilterView.swift
//  SmartSpend
//
//  Created by Refik Jaija on 27.8.25.
//

import SwiftUI

struct TransactionsFilterView: View {
    @State private var showFilters = false
    @StateObject private var viewModel = TransactionViewModel()
    
    var body: some View {
        VStack(spacing: 12) {
            
            // Top bar
            HStack {
                Text("\(viewModel.startDate.formatted(date: .abbreviated, time: .omitted)) - \(viewModel.endDate.formatted(date: .abbreviated, time: .omitted))")
                    .font(.caption)
                Spacer()
                Button {
                    withAnimation {
                        showFilters.toggle()
                    }
                } label: {
                    Image(systemName: "line.3.horizontal.decrease.circle")
                        .foregroundStyle(.black)
                        .frame(width: 40, height: 30)
                }
                .background(Color.MainColor)
                .cornerRadius(4)
                .shadow(radius: 2)
            }
            .padding()
            .frame(maxWidth: 370)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.MainColor.opacity(0.15))
                    .shadow(radius: 2)
            )
            
            // Show this only if filter button is pressed
            if showFilters {
                HStack {
                    DatePicker("From", selection: $viewModel.startDate, displayedComponents: .date)
                        .labelsHidden()
                    DatePicker("To", selection: $viewModel.endDate, displayedComponents: .date)
                        .labelsHidden()
                    
                    Button {
                        Task {
                            await viewModel.fetchTransactions()
                        }
                    } label: {
                        Text("Apply")
                            .foregroundStyle(.black)
                            .frame(maxWidth: .infinity, minHeight: 30)
                    }
                    .background(Color.MainColor)
                    .cornerRadius(4)
                    .shadow(radius: 2)
                }
                .padding()
                .transition(.opacity.combined(with: .move(edge: .top))) // smooth animation
            }
        }
    }
}

#Preview {
    TransactionsFilterView()
}
