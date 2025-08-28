//
//  AddView.swift
//  SmartSpend
//
//  Created by Refik Jaija on 17.8.25.
//
//
//import SwiftUI
//
//struct AddBottomSheetView: View {
//    @StateObject private var viewModel = AddBottomSheetViewModel()
//    
//    var body: some View {
//        
//        VStack{
//            Picker("Type of add", selection: $viewModel.selected){
//                Text("Inceome").tag(1)
//                Text("Expense").tag(2)
//                
//            }.pickerStyle(.segmented)
//                .padding()
//            
//            Spacer()
//            if viewModel.selected == 1{
//                
//                Button(action: {
//                    
//                }) {
//                    HStack {
//                        Text("Add")
//                            .foregroundStyle(.white)
//                    }
//                    .frame(maxWidth: .infinity, minHeight: 60)
//                    .background(Color.MainColor)
//                    .cornerRadius(12)
//                    .shadow(radius: 2)
//                }
//                .padding()
//                
//            } else if viewModel.selected == 2{
//                VStack{
//                    
//                    
//                    Button(action: {
//                        
//                    }) {
//                        HStack {
//                            Image(systemName: "camera")
//                                .resizable()
//                                .scaledToFit()
//                                .frame(width: 40, height: 40)
//                                .foregroundStyle(.gray)
//                            
//                        }
//                        .frame(maxWidth: .infinity, minHeight: 60)
//                        .background(Color.white)
//                        .cornerRadius(12)
//                        .shadow(radius: 2)
//                    }
//                    .padding()
//                    
//                    
//                    Button(action: {
//                        
//                    }) {
//                        HStack {
//                            Text("Add manually")
//                                .foregroundStyle(.white)
//                        }
//                        .frame(maxWidth: .infinity, minHeight: 60)
//                        .background(Color.MainColor)
//                        .cornerRadius(12)
//                        .shadow(radius: 2)
//                    }
//                    .padding()
//                    
//                }
//            }
//            
//            Spacer()
//            
//        }
//        
//        
//        
//    }
//}
//
//
//#Preview {
//    AddBottomSheetView()
//}


import SwiftUI

struct AddBottomSheetView: View {
    @StateObject private var viewModel = AddBottomSheetViewModel()
    
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
                        AddIncomeView()
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
                            AddExpenseView()
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
    AddBottomSheetView()
}
