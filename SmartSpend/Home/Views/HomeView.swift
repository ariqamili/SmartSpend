////
////  HomeView.swift
////  SmartSpend
////
////  Created by Refik Jaija on 17.8.25.
////

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @EnvironmentObject var userVM: UserViewModel
    @EnvironmentObject var transactionVM: TransactionViewModel
    

    var body: some View {
        
        SmartSpendNavigationView(){
            ScrollView {
                VStack(spacing: 20) {
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Your Balance")
                            .font(.caption)
                            .frame(maxWidth: 370, alignment: .leading)
                            .foregroundStyle(.gray)
                        
//                            .padding(.leading)
                        HStack {
                            if viewModel.show {
                                Text(
                                    userVM.currentUser?.balance.formatted(
                                        .currency(code: userVM.currentUser?.preferred_currency.rawValue ?? User.Currency.MKD.rawValue)
                                    ) ?? "****"
                                )
                                .font(.system(size: 35))
                                .frame(maxWidth: 370, alignment: .leading)
                                .foregroundStyle(Color.MainColor)

                            } else {
                                Text("**** \(userVM.currentUser?.preferred_currency.rawValue ?? User.Currency.MKD.rawValue)")
                                    .font(.system(size: 35))
                                    .frame(maxWidth: 370, alignment: .leading)
                                    .foregroundStyle(Color.MainColor)
                            }
                            
                            Spacer()
                            
                            Button {
                                viewModel.toggleVisibility()
                            } label: {
                                if viewModel.show {
                                    Image(systemName:"eye.slash")
                                        .foregroundStyle(.gray)
                                } else {
                                    Image(systemName:"eye")
                                        .foregroundStyle(.gray)
                                }
                            }
                        }
                        .padding(.trailing)
                    }
                    .padding(.leading)
                    
                    TransactionPartialView()
                    
                    SavingsPartialView(isOnHomeScreen: true)
                    
                    PieChart(isOnHomeView: true)
                }
            }
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(UserViewModel())
        .environmentObject(TransactionViewModel())
}
