////
////  TransactionPartialView.swift
////  SmartSpend
////
////  Created by Refik Jaija on 26.8.25.
////
//
//import SwiftUI
//
//struct TransactionPartialView: View {
//    @EnvironmentObject var transactionVM: TransactionViewModel
//
//    var body: some View {
//        
//        NavigationStack{
//            NavigationLink("View More"){
//                TransactionsFullView()
//            }
//            .frame(maxWidth: 340, alignment: .trailing)
//            .foregroundStyle(Color.MainColor)
//            .padding(.top)
//            .font(.footnote)
//            
//
//
//            
//            List(transactionVM.transactions.suffix(3)){ transaction in
//                HStack(alignment: .center, spacing: nil){
//                    if (transaction.type == .income){
//                        Image(systemName: "arrow.down.backward").foregroundStyle(.green)
//                            
//                        
//                        Text("\(transaction.title)")
//                            .frame(maxWidth: .infinity, alignment: .leading)
//                        
//                        Text("+ \(String(format: "%.2f", transaction.price))")
//                            .foregroundStyle(.green)
//                            .frame(alignment: .leading)
//                        
//                    }
//                    else{
//                        Image(systemName: "arrow.up.forward").foregroundStyle(.red)
//                            
//                        
//                        Text("\(transaction.title)")
//                            .frame(maxWidth: .infinity, alignment: .leading)
//                        
//                        Text("- \(String(format: "%.2f", transaction.price))")
//                            .foregroundStyle(.red)
//                            .frame(alignment: .leading)
//                        
//                    }
//                    
//                }
//                .listRowBackground(Color.MainColor.opacity(0.15))
//                .padding(7.5)
//            }
//            .contentMargins(.vertical, 0)
////            .scrollContentBackground(.hidden)
//            .listRowSpacing(10)
////            .frame(height: .infinity)
//            
//        }
////        .task {
////            // Fetch transactions on appear
////            await viewModel.fetchTransactions()
////        }
//
//    }
//}
//
//#Preview {
//    TransactionPartialView()
//        .environmentObject(TransactionViewModel())
//}


//
//  TransactionPartialView.swift
//  SmartSpend
//
//  Created by Refik Jaija on 26.8.25.
//

import SwiftUI

struct TransactionPartialView: View {
    @EnvironmentObject var transactionVM: TransactionViewModel

    var body: some View {
        VStack(spacing: 10) {
            // View More Link
            NavigationLink("View More") {
                TransactionsFullView()
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
            .foregroundStyle(Color.MainColor)
            .font(.footnote)
            .padding(.horizontal, 30)
            
            
            // Recent Transactions (last 3)
            VStack(spacing: 10) {
                ForEach(transactionVM.transactions.suffix(3)) { transaction in
                    HStack(alignment: .center) {
                        if transaction.type == .income {
                            Image(systemName: "arrow.down.backward")
                                .foregroundStyle(.green)
                                .font(.system(size: 16))
                            
                            Text("\(transaction.title)")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .font(.body)
                            
                            Text("+ \(String(format: "%.2f", transaction.price))")
                                .foregroundStyle(.green)
                                .font(.body)
                                .fontWeight(.medium)
                        } else {
                            Image(systemName: "arrow.up.forward")
                                .foregroundStyle(.red)
                                .font(.system(size: 16))
                            
                            Text("\(transaction.title)")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .font(.body)
                            
                            Text("- \(String(format: "%.2f", transaction.price))")
                                .foregroundStyle(.red)
                                .font(.body)
                                .fontWeight(.medium)
                        }
                    }
                    .padding(.vertical, 12)
                    .padding(.horizontal, 16)
                    .background(Color.MainColor.opacity(0.15))
                    .cornerRadius(12)
                    .padding(.horizontal)
                }
            }
        }
    }
}


#Preview {
    TransactionPartialView()
        .environmentObject(TransactionViewModel())
}
