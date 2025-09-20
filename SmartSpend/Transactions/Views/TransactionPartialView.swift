//
//  TransactionPartialView.swift
//  SmartSpend
//
//  Created by Refik Jaija on 26.8.25.
//

import SwiftUI

struct TransactionPartialView: View {
    @EnvironmentObject var transactionVM: TransactionViewModel
    @EnvironmentObject var userVM: UserViewModel

    var body: some View {
        
        NavigationStack{
            NavigationLink("View More"){
                TransactionsFullView()
                    .environmentObject(transactionVM)
            }
            .frame(maxWidth: 340, alignment: .trailing)
            .foregroundStyle(Color.MainColor)
//            .padding(.top)
            .font(.footnote)
            


            
            List(transactionVM.transactions.suffix(3)){ transaction in
                HStack(alignment: .center, spacing: nil){
                    if (transaction.type == .income){
                        Image(systemName: "arrow.down.backward").foregroundStyle(.green)
                            
                        
                        let words = transaction.title.split(separator: " ")
                        let displayTitle = words.count > 1 ? "\(words.first!)..." : transaction.title

                        Text(displayTitle)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        
                        Text("+ \(String(format: "%.2f", transaction.price))")
                            .foregroundStyle(.green)
                            .frame(alignment: .leading)
                        
                        Text(userVM.currentUser?.preferred_currency.rawValue ?? User.Currency.MKD.rawValue)
                            .foregroundStyle(.green)
                        
                    }
                    else{
                        Image(systemName: "arrow.up.forward").foregroundStyle(.red)
                            
                        
                        let words = transaction.title.split(separator: " ")
                        let displayTitle = words.count > 1 ? "\(words.first!)..." : transaction.title

                        Text(displayTitle)
                            .frame(maxWidth: .infinity, alignment: .leading)


                        
                        Text("- \(String(format: "%.2f", transaction.price))")
                            .foregroundStyle(.red)
                            .frame(alignment: .leading)
                        
                        Text(userVM.currentUser?.preferred_currency.rawValue ?? User.Currency.MKD.rawValue)
                            .foregroundStyle(.red)

                        
                    }
                    
                }
                .listRowBackground(Color.MainColor.opacity(0.15))
//                .padding(3.5)
                .frame(maxWidth: .infinity)
            }
            .contentMargins(.vertical, 0)
            .scrollContentBackground(.hidden)
            .listRowSpacing(10)
            .frame(height: 180)
            .scrollDisabled(true)
            
        }
        .task {
            await transactionVM.fetchTransactions()
        }

    }
}

#Preview {
    TransactionPartialView()
        .environmentObject(TransactionViewModel())
        .environmentObject(UserViewModel())
}
