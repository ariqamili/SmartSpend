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

    
    var body: some View {
        NavigationStack {
            Form{
                TextField("Title", text: $viewModel.incomeTitle)
                
                TextField("Price", text: $viewModel.incomePrice)
                    .keyboardType(.decimalPad)
                    .onChange(of: viewModel.incomePrice) { oldValue, newValue in
                        let filtered = newValue.filter { "0123456789.".contains($0) }
                        if filtered != newValue {
                            viewModel.incomePrice = filtered
                        }
                    }

                DatePicker("Date", selection: $viewModel.incomeDate, displayedComponents: .date)
                    .foregroundStyle(Color.MainColor)


            }
            .listRowSpacing(20)
            
            
            
            
            Button(action: {
                Task{
                    await viewModel.AddIncome()
                }
            }) {
                HStack {
                    Text("Submit")
                        .foregroundStyle(.white)
                }
                .frame(maxWidth: .infinity, minHeight: 60)
                .background(Color.MainColor)
                .cornerRadius(12)
                .shadow(radius: 2)
            }
            .padding()
            
            
        }
        .toolbar{
            ToolbarItem(placement: .principal) {
                Text("Add Income")
                    .foregroundStyle(Color.MainColor)
            }
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
