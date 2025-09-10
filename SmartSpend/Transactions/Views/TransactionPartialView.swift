//
//  TransactionPartialView.swift
//  SmartSpend
//
//  Created by Refik Jaija on 26.8.25.
//

import SwiftUI

struct TransactionPartialView: View {
    @StateObject private var viewModel: TransactionViewModel = TransactionViewModel()
    
    var body: some View {
        
        NavigationStack{
            NavigationLink("View More"){
                TransactionsFullView()
            }
            .frame(maxWidth: 340, alignment: .trailing)
            .foregroundStyle(Color.MainColor)
            .padding(.top)
            .font(.footnote)
            


            
            List(viewModel.transactions.suffix(3)){ transaction in
                HStack(alignment: .center, spacing: nil){
                    if (transaction.type == .income){
                        Image(systemName: "arrow.down.backward").foregroundStyle(.green)
                            
                        
                        Text("\(transaction.title)")
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Text("+ \(String(format: "%.2f", transaction.price))")
                            .foregroundStyle(.green)
                            .frame(alignment: .leading)
                        
                    }
                    else{
                        Image(systemName: "arrow.up.forward").foregroundStyle(.red)
                            
                        
                        Text("\(transaction.title)")
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Text("- \(String(format: "%.2f", transaction.price))")
                            .foregroundStyle(.red)
                            .frame(alignment: .leading)
                        
                    }
                    
                }
                .listRowBackground(Color.MainColor.opacity(0.15))
                .padding(7.5)
            }
            .contentMargins(.vertical, 0)
//            .scrollContentBackground(.hidden)
            .listRowSpacing(10)
            .frame(height: .infinity)
            
        }
//        .task {
//            // Fetch transactions on appear
//            await viewModel.fetchTransactions()
//        }

    }
}

#Preview {
    TransactionPartialView()
}
