//
//  AddIncomeView.swift
//  SmartSpend
//
//  Created by Refik Jaija on 28.8.25.
//

import SwiftUI


struct AddIncomeView: View {
    
    @EnvironmentObject var transactionVM: TransactionViewModel
    @EnvironmentObject var userVM: UserViewModel
    @EnvironmentObject var categoryVM: CategoryViewModel
    @ObservedObject var viewModel: AddBottomSheetViewModel
    @State private var showAlert = false
    @State private var alertMessage = ""

    
    var body: some View {
        NavigationStack {
            Form{
                TextField("Title", text: $viewModel.incomeTitle)
                    .padding(8)
                    .listRowBackground(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 2)
                    )
 
                
                
                TextField("Price:  \(userVM.currentUser?.preferred_currency ?? User.Currency.MKD)" as String, text: $viewModel.incomePrice)
                    .keyboardType(.decimalPad)
                    .onChange(of: viewModel.incomePrice) { oldValue, newValue in
                        let filtered = newValue.filter { "0123456789.".contains($0) }
                        if filtered != newValue {
                            viewModel.incomePrice = filtered
                        }
                    }
                    .padding(8)
                    .listRowBackground(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 2)
                    )


                DatePicker("Date", selection: $viewModel.incomeDate, displayedComponents: .date)
                    .foregroundStyle(Color.MainColor)
                    .padding(4)
                    .listRowBackground(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 2)
                    )

                Spacer()
                Spacer()
                
                Button("Submit") {
                    Task {
                        let success = await viewModel.AddIncome()
                        if success {
                            alertMessage = "Income added successfully!"
                        } else {
                            alertMessage = "Failed to add income. Try again."
                        }
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
            .listRowSpacing(20)
            .scrollContentBackground(.hidden)
            

            
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
    let transactionVM = TransactionViewModel()
    let userVM = UserViewModel()
    let categoryVM = CategoryViewModel()
    let addVM = AddBottomSheetViewModel(
        transactionVM: transactionVM,
        userVM: userVM,
        categoryVM: categoryVM
    )

    return AddIncomeView(viewModel: addVM)
        .environmentObject(transactionVM)
        .environmentObject(userVM)
        .environmentObject(categoryVM)
}
