//
//  AddExpenseView.swift
//  SmartSpend
//
//  Created by Refik Jaija on 28.8.25.
//

import SwiftUI

struct AddExpenseView: View {
    
    @EnvironmentObject var transactionVM: TransactionViewModel
    @EnvironmentObject var userVM: UserViewModel
    @EnvironmentObject var categoryVM: CategoryViewModel
    @ObservedObject var viewModel: AddBottomSheetViewModel
    @State private var showAlert = false
    @State private var alertMessage = ""
    

    
    var body: some View {
        NavigationStack {
            ZStack {
                Form{
                    TextField("Title", text: $viewModel.expenseTitle)
                        .listRowBackground(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray, lineWidth: 2)
                        )
                    
                    
                    
                    Picker("Category", selection: $viewModel.expenseCategory){
                        ForEach(categoryVM.categories){ category in
                            Text(category.name)
                                .tag(category.id)
                        }
                    }
                    .foregroundStyle(Color.MainColor)
                    .listRowBackground(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 2)
                    )
                    
                    
                    TextField("Price:  \(userVM.currentUser?.preferred_currency ?? User.Currency.MKD)" as String, text: $viewModel.expensePrice)
                        .keyboardType(.decimalPad)
                        .onChange(of: viewModel.expensePrice) { oldValue, newValue in
                            let filtered = newValue.filter { "0123456789.".contains($0) }
                            if filtered != newValue {
                                viewModel.expensePrice = filtered
                            }
                        }
                        .listRowBackground(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray, lineWidth: 2)
                        )
                    
                    
                    DatePicker("Date", selection: $viewModel.expenseDate, displayedComponents: .date)
                        .foregroundStyle(Color.MainColor)
                        .listRowBackground(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray, lineWidth: 2)
                        )
                    
                    
                    
                    Button("Submit") {
                        Task {
                            let success = await viewModel.AddExpense()
                            if success {
                                alertMessage = "Expense added successfully!"
                            } else {
                                alertMessage = "Failed to add expense. Try again."
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
            if viewModel.isAnalyzingReceipt {
//                    Color.black.opacity(0.4)
//                        .ignoresSafeArea()
                    
                    VStack(spacing: 12) {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .scaleEffect(1.5)
                        
                        Text("Processing receipt…")
                            .foregroundColor(.white)
                            .font(.headline)
                            .transition(.opacity.combined(with: .scale))
                    }
                    .padding()
                    .background(Color.black.opacity(0.7))
                    .cornerRadius(16)
                    .shadow(radius: 10)
                    .animation(.easeInOut, value: viewModel.isAnalyzingReceipt)
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
    let transactionVM = TransactionViewModel()
    let userVM = UserViewModel()
    let categoryVM = CategoryViewModel()
    let addVM = AddBottomSheetViewModel(
        transactionVM: transactionVM,
        userVM: userVM,
        categoryVM: categoryVM
    )

    return AddExpenseView(viewModel: addVM)
        .environmentObject(transactionVM)
        .environmentObject(userVM)
        .environmentObject(categoryVM)
}

#if canImport(UIKit)
extension View {
    func hideKeyboard(){
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif

