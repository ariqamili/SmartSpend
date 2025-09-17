//
//  EditTransactionView.swift
//  SmartSpend
//
//  Created by Refik Jaija on 10.9.25.
//
import SwiftUI

struct EditTransactionView: View {
    @EnvironmentObject var transactionVM: TransactionViewModel
    @EnvironmentObject var userVM: UserViewModel
    @EnvironmentObject var categoryVM: CategoryViewModel
    
    let transaction: Transaction
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State var title: String = ""
    @State var price: String = ""
    var priceBool: Double {
        Double(price) ?? 0.0
    }
    @State var date: Date = Date()
    @State var category: Int64 = 1
        

    

    
    var body: some View {
        NavigationStack {
            Form{
                
                Section(transaction.type == .income ? "Income Info" : "Expense Info")
                {
                    TextField("Title", text: $title)
                    
                    if transaction.type == .expense {
                        Picker("Category", selection: $category){
                            ForEach(categoryVM.categories){ category in
                                Text(category.name)
                                    .tag(category.id)
                            }
                        }

                    }
                    
                    
                    TextField("Price:  \(userVM.currentUser?.preferred_currency ?? User.Currency.MKD)" as String, text: $price)
                        .keyboardType(.decimalPad)
                        .onChange(of: price) { oldValue, newValue in
                            let filtered = newValue.filter { "0123456789.".contains($0) }
                            if filtered != newValue {
                                price = filtered
                            }
                        }
                    
                    
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                        .foregroundStyle(Color.MainColor)
                        
                    
                }
                
                Button("Submit") {
                    Task {
                        if transaction.type == .income{
                            await transactionVM.editTransaction(id: transaction.id!, title: title, price: priceBool, date_made: date, category_id: transaction.category_id)

                        }
                        else{
                            await transactionVM.editTransaction(id: transaction.id!, title: title, price: priceBool, date_made: date, category_id: category)

                        }
                        await transactionVM.fetchTransactions()
                        
                        alertMessage = "Transaction updated successfully!"
                        showAlert = true

                    }
                }
                .frame(maxWidth: .infinity)
                .padding(10)
                .foregroundStyle(.white)
                .listRowBackground(Color.MainColor)
                .alert("Result", isPresented: $showAlert) {
                    Button("OK", role: .cancel) {}
                } message: {
                    Text(alertMessage)
                }



            }
            .navigationTitle("Edit Transaction")
            .onAppear(){
                title = transaction.title
                price = String(transaction.price)
                date = transaction.date_made
                category = transaction.category_id ?? 1
                
            }


            
        }
        .toolbar{
            ToolbarItem(placement: .keyboard) {
                Spacer()
            }
            ToolbarItem(placement: .keyboard) {
                Button{
                    hideKeyboard()
                } label: {
                    Image(systemName:"keyboard.chevron.compact.down.fill")
                }
            }
            
        }
        .tint(Color.MainColor)
        
    }
}


#Preview {
    let sampleTransaction = Transaction(
        id: 3,
        title: "Salary",
        price: 120005,
        date_made: Date().addingTimeInterval(-86400 * 2),
        category_id: 3,
        type: .income
        
    )
    EditTransactionView(transaction: sampleTransaction)
        .environmentObject(TransactionViewModel())
        .environmentObject(UserViewModel())
        .environmentObject(CategoryViewModel())
}

