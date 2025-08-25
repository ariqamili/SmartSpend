////
////  HomeView.swift
////  SmartSpend
////
////  Created by Refik Jaija on 17.8.25.
////

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    
    var body: some View {
        
        SmartSpendNavigationView(){
            VStack{
                Text("Your Balance")
                    .font(.caption)
                    .frame(maxWidth: 370, alignment: .leading)
                    .foregroundStyle(.gray)
                    .padding(.top)
                    .padding(.top)
                
                HStack{
                    if viewModel.show {
                        Text("\(viewModel.balance.formatted(.currency(code: viewModel.currency)))")
                            .font(.system(size: 35))
                            .frame(maxWidth: 370, alignment: .leading)
                            .foregroundStyle(.black)
                    } else{
                        Text("**** \(viewModel.currency)")
                            .font(.system(size: 35))
                            .frame(maxWidth: 370, alignment: .leading)
                            .foregroundStyle(.black)
                    }
                    
                    
                    Button {
                        viewModel.toggleVisibility()
                    } label: {
                        if viewModel.show{
                            Image(systemName:"eye.slash")
                                .foregroundStyle(.black)
                        } else{
                            Image(systemName:"eye")
                                .foregroundStyle(.black)
                        }
                    
                        
                    }

                }
                .padding(.horizontal)

    
                
                
                Spacer()
                
            }
        }
        
        
    }
    
}

#Preview {
    HomeView()
}



