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
    @State var showEditSheet: Bool = false
    

    var body: some View {
        
        
        
        SmartSpendNavigationView(){
            ScrollView{
                VStack{
                    HStack{
                        Text("Your Balance")
                            .font(.caption)
                            .frame(maxWidth: 370, alignment: .leading)
                            .foregroundStyle(.gray)
                        
                        Button(action:{
                            showEditSheet = true
                        }, label:{
                            Text("Edit Balance")
                        })
                        .foregroundColor(.MainColor)
                        .font(.footnote)
                        .padding(.trailing)
                    }
                    .padding()
                    
                    HStack{
                        
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
                    
                    SavingsPartialView()
                    
                    
                    
                    Spacer()
                    
                }
            }
            .sheet(isPresented: $showEditSheet) {
                EditBalanceView()
                    .presentationDetents([.fraction(0.3)])

            }

        }
        
        
    }
    
}

#Preview {
    HomeView()
        .environmentObject(UserViewModel())
        .environmentObject(TransactionViewModel())
}



