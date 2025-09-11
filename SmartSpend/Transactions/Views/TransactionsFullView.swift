//////
//////  TransactionsFullView.swift
//////  SmartSpend
//////
//////  Created by Refik Jaija on 26.8.25.
//////
import SwiftUI
struct TransactionsFullView: View {
    @EnvironmentObject var transactionVM: TransactionViewModel
    @EnvironmentObject var userVM: UserViewModel
    @State private var selectedTransaction: Transaction?
    @State private var showingEditSheet = false
    
    var body: some View {
        let grouped = transactionVM.transactions.groupedByDay()
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
                                    HStack{
                                        Text(transaction.type == .income ? "+ \(transaction.price, specifier: "%.2f")" : "-\(transaction.price, specifier: "%.2f")")
                                        Text(userVM.currentUser?.preferred_currency.rawValue ?? User.Currency.MKD.rawValue)
                                        
                                    }
                                    .foregroundStyle(transaction.type == .income ? .green : .red)
                                }
                                .listRowSeparator(.hidden)
                                .swipeActions(edge: .trailing){
                                    Button(action:{
                                        Task{
                                            guard let id = transaction.id else { return }
                                            await transactionVM.deleteTransaction(id: id)
                                            await transactionVM.fetchTransactions()

                                        }

                                    }, label:{
                                        Image(systemName: "trash")
                                    })
                                    .tint(Color.LogOutColor)
                                    
                                    Button(action:{
                                        selectedTransaction = transaction
                                        showingEditSheet = true
                                    }, label:{
                                        Image(systemName: "pencil")
                                    })
                                }
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
            .sheet(item: $selectedTransaction) { transaction in
                EditTransactionView(transaction: transaction)
            }
            .task {
                await transactionVM.fetchTransactions()
            }
        }
    }
}
#Preview {
    TransactionsFullView()
        .environmentObject(TransactionViewModel())
        .environmentObject(UserViewModel())
        .environmentObject(CategoryViewModel())
}
