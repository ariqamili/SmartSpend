//
//  AddBottomSheetView.swift
//  SmartSpend
//
//  Created by Refik Jaija on 17.8.25.
//

import SwiftUI

struct AddBottomSheetView: View {
    
    @EnvironmentObject var transactionVM: TransactionViewModel
    @EnvironmentObject var userVM: UserViewModel
    @EnvironmentObject var categoryVM: CategoryViewModel
    @StateObject private var viewModel: AddBottomSheetViewModel
    
    @State private var showCamera = false
    @State private var capturedImage: UIImage?
    
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
                    AddIncomeView(viewModel: viewModel)
                } else if viewModel.selected == 2 {
                    VStack {
                        Button(action: {
                            showCamera = true
                        }) {
                            HStack {
                                Text("Take a picture")
                                    .foregroundStyle(.gray)
                                Image(systemName: "camera")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 40, height: 40)
                                    .foregroundStyle(.gray)
                            }
                            .frame(maxWidth: 360, minHeight: 60)
                            .background(Color.white)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(style: StrokeStyle(lineWidth: 1, dash: [6]))
                                    .foregroundColor(.gray)
                            )
                        }
                        .sheet(isPresented: $showCamera) {
                            ImagePicker(sourceType: .camera) { image in
                                capturedImage = image
                                if let img = image {
                                    Task {
                                        await viewModel.analyzeReceipt(receiptImage: img)
                                    }
                                }
                            }
                        }
                        
                        AddExpenseView(viewModel: viewModel)
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
