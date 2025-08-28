//////
//////  TransactionsFullView.swift
//////  SmartSpend
//////
//////  Created by Refik Jaija on 26.8.25.
//////
//
//import SwiftUI
//
//struct TransactionsFullView: View {
//    @StateObject private var viewModel = TransactionViewModel()
//    
//    var body: some View {
//        let grouped = viewModel.transactions.groupedByDay()
//        let sortedDays = grouped.keys.sorted(by: >) // newest first
//        
//        NavigationStack{
//            
//            List {
//                ForEach(sortedDays, id: \.self) { day in
//                    Section(
//                        header: Text(day.formatted(date: .abbreviated, time: .omitted))
//                            .font(.callout)
//                            .foregroundColor(.gray)
//                    ) {
//                        ForEach(grouped[day] ?? []) { transaction in
//                            
//                            HStack {
//                                
//                                transaction.type == .expense ? Image(systemName: "arrow.up.forward").foregroundStyle(.red) : Image(systemName: "arrow.down.backward").foregroundStyle(.green)
//                                
//                                
//                                Text(transaction.title)
//                                Spacer()
//                                Text(transaction.type == .income ? "+ \(transaction.amount, specifier: "%.2f")" : "-\(transaction.amount, specifier: "%.2f")")
//                                    .foregroundStyle(transaction.type == .income ? .green : .red)
//                            }
//                            .listRowSeparator(.hidden)
//                        }
//                    }
//                }
//            }
//            .scrollContentBackground(.hidden)
//            .toolbar{
//                ToolbarItem(placement: .principal){
//                    Text("Transactions")
//                }
//            }
//            //        .task {
//            //            await viewModel.fetchTransactions()
//            //        }
//        }
//        
//    }
//}
//
//#Preview {
//    TransactionsFullView()
//}
//

import SwiftUI

struct TransactionsFullView: View {
    @StateObject private var viewModel = TransactionViewModel()
    
    var body: some View {
        let grouped = viewModel.transactions.groupedByDay()
        let sortedDays = grouped.keys.sorted(by: >) // newest first
        
        NavigationStack {
            VStack {
                
                TransactionsFilterView()
                
                
                List {
                    ForEach(sortedDays, id: \.self) { day in
                        Section(
                            header: Text(day.formatted(date: .abbreviated, time: .omitted))
                                .font(.callout)
                                .foregroundColor(.gray)
                        ) {
                            ForEach(grouped[day] ?? []) { transaction in
                                HStack {
                                    transaction.type == .expense
                                        ? Image(systemName: "arrow.up.forward").foregroundStyle(.red)
                                        : Image(systemName: "arrow.down.backward").foregroundStyle(.green)

                                    Text(transaction.title)
                                    Spacer()
                                    Text(transaction.type == .income ? "+ \(transaction.price, specifier: "%.2f")" : "-\(transaction.price, specifier: "%.2f")")
                                        .foregroundStyle(transaction.type == .income ? .green : .red)
                                }
                                .listRowSeparator(.hidden)
                            }
                        }
                    }
                }
                .scrollContentBackground(.hidden)
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Transactions")
                }
            }
//            .task {
//                await viewModel.fetchTransactions()
//            }
        }
    }
}



#Preview {
    TransactionsFullView()
}


