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
                        .padding()
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
    
    private func uploadReceiptImage(_ image: UIImage) {
        guard let url = URL(string: "https://your-backend.com/api/upload") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let imageData = image.jpegData(compressionQuality: 0.8) ?? Data()
        var body = Data()
        
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"file\"; filename=\"receipt.jpg\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        body.append(imageData)
        body.append("\r\n".data(using: .utf8)!)
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = body
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Upload error: \(error)")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("Upload finished with status: \(httpResponse.statusCode)")
            }
        }.resume()
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
