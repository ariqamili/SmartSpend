////
////  HomeView.swift
////  SmartSpend
////
////  Created by Refik Jaija on 17.8.25.
////

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @StateObject private var viewModelUser = UserViewModel()

    var body: some View {
        
        SmartSpendNavigationView(){
            VStack{
                Text("Your Balance")
                    .font(.caption)
                    .frame(maxWidth: 370, alignment: .leading)
                    .foregroundStyle(.gray)                
                HStack{
                    if viewModel.show {
//                        Text("\(viewModelUser.currentUser?.balance.formatted(.currency(code: viewModelUser.currentUser?.preferredCurrency ?? "USD")) ?? "****")")
                        Text("\(viewModel.balance.formatted(.currency(code: viewModel.currency)))")
                            .font(.system(size: 35))
                            .frame(maxWidth: 370, alignment: .leading)
                            .foregroundStyle(Color.MainColor)
                    } else{
                        Text("**** \(viewModel.currency)")
                            .font(.system(size: 35))
                            .frame(maxWidth: 370, alignment: .leading)
                            .foregroundStyle(Color.MainColor)
                    }
                    
                    
                    Button {
                        viewModel.toggleVisibility()
                    } label: {
                        if viewModel.show{
                            Image(systemName:"eye.slash")
                                .foregroundStyle(.gray)
                        } else{
                            Image(systemName:"eye")
                                .foregroundStyle(.gray)
                        }
                    
                        
                    }

                }
                .padding(.horizontal)
        
        
               TransactionPartialView()
    
                
                
                Spacer()
                
            }
        }
        
        
    }
    
}

#Preview {
    HomeView()
}



