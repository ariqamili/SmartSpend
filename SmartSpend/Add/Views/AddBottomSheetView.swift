//
//  AddView.swift
//  SmartSpend
//
//  Created by Refik Jaija on 17.8.25.
//
//


import SwiftUI

struct AddBottomSheetView: View {
    
    @EnvironmentObject var transactionVM: TransactionViewModel
    @EnvironmentObject var userVM: UserViewModel
    @EnvironmentObject var categoryVM: CategoryViewModel
    @StateObject private var viewModel: AddBottomSheetViewModel

    init(transactionVM: TransactionViewModel, userVM: UserViewModel, categoryVM: CategoryViewModel) {
        _viewModel = StateObject(
            wrappedValue: AddBottomSheetViewModel(
                transactionVM: transactionVM,
                userVM: userVM,
                categoryVM: categoryVM
            )
        )
    }

    var body: some View {
        NavigationStack {
            VStack {
                Picker("Type of add", selection: $viewModel.selected) {
                    Text("Income").tag(1)
                    Text("Expense").tag(2)
                }
                .pickerStyle(.segmented)
                .padding()
                
                Spacer()
                
                if viewModel.selected == 1 {
                    NavigationLink {
                        AddIncomeView(viewModel: viewModel)
                    } label: {
                        HStack {
                            Text("Add")
                                .foregroundStyle(.white)
                        }
                        .frame(maxWidth: .infinity, minHeight: 60)
                        .background(Color.MainColor)
                        .cornerRadius(12)
                        .shadow(radius: 2)
                    }
                    .padding()
                    
                } else if viewModel.selected == 2 {
                    VStack {
                        Button(action: {
                            // camera action
                        }) {
                            HStack {
                                Image(systemName: "camera")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 40, height: 40)
                                    .foregroundStyle(.gray)
                            }
                            .frame(maxWidth: .infinity, minHeight: 60)
                            .background(Color.white)
                            .cornerRadius(12)
                            .shadow(radius: 2)
                        }
                        .padding()
                        
                        
                        NavigationLink {
                            AddExpenseView(viewModel: viewModel)
                        } label: {
                            HStack {
                                Text("Add manually")
                                    .foregroundStyle(.white)
                            }
                            .frame(maxWidth: .infinity, minHeight: 60)
                            .background(Color.MainColor)
                            .cornerRadius(12)
                            .shadow(radius: 2)
                        }
                        .padding()
                    }
                }
                
                Spacer()
            }
        }
    }
}


#Preview {
    AddBottomSheetView(
        transactionVM: TransactionViewModel(),
        userVM: UserViewModel(),
        categoryVM: CategoryViewModel()
    )
    .environmentObject(TransactionViewModel())
    .environmentObject(UserViewModel())
    .environmentObject(CategoryViewModel())
}
