//
//  TransactionsFilterView.swift
//  SmartSpend
//
//  Created by Refik Jaija on 27.8.25.
//

import SwiftUI

struct TransactionsFilterView: View {
    @State private var showFilters = false
    @EnvironmentObject var transactionVM: TransactionViewModel

    
    var body: some View {
        VStack(spacing: 12) {
            
            // Top bar
            HStack {
                Text("\(transactionVM.startDate.formatted(date: .abbreviated, time: .omitted)) - \(transactionVM.endDate.formatted(date: .abbreviated, time: .omitted))")
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
                    DatePicker("From", selection: $transactionVM.startDate, displayedComponents: .date)
                        .labelsHidden()
                    DatePicker("To", selection: $transactionVM.endDate, displayedComponents: .date)
                        .labelsHidden()
                    
                    Button {
                        Task {
                            await transactionVM.fetchTransactions()
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
                .transition(.opacity.combined(with: .move(edge: .top))) 
            }
        }
    }
}

#Preview {
    TransactionsFilterView()
        .environmentObject(TransactionViewModel())
}
