//
//  AddExpenseView.swift
//  SmartSpend
//
//  Created by Refik Jaija on 28.8.25.
//

import SwiftUI

struct AddExpenseView: View {
    
    @StateObject private var viewModel = AddBottomSheetViewModel()
    @StateObject private var categoryVM = CategoryViewModel()
    
    var body: some View {
        NavigationStack {
            Form{
                TextField("Title", text: $viewModel.expenseTitle)
                    

                Picker("Category", selection: $viewModel.expenseCategory){
                    ForEach(categoryVM.categories2){ category in
                        Text("\(category.name)")
                    }
                }.foregroundStyle(Color.MainColor)
                
                
                TextField("Price", text: $viewModel.expensePrice)
                    .keyboardType(.decimalPad)
                    .onChange(of: viewModel.expensePrice) { oldValue, newValue in
                        let filtered = newValue.filter { "0123456789.".contains($0) }
                        if filtered != newValue {
                            viewModel.expensePrice = filtered
                        }
                    }

                DatePicker("Date", selection: $viewModel.expenseDate, displayedComponents: .date)
                    .foregroundStyle(Color.MainColor)


            }
            .listRowSpacing(20)
            
            
            
            
            Button(action: {
                Task{
                    await viewModel.AddExpense()
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
                Text("Add Expense")
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
    AddExpenseView()
}


#if canImport(UIKit)
extension View {
    func hideKeyboard(){
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif

