////
////  HomeView.swift
////  SmartSpend
////
////  Created by Refik Jaija on 17.8.25.
////

import SwiftUI

struct HomeView: View {
    @State var currency: String = "MKD"
    @State var balance: Double = 20000
    @State var show: Bool = true
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
                    if show {
                        Text("\(balance.formatted(.currency(code: currency)))")
                            .font(.system(size: 35))
                            .frame(maxWidth: 370, alignment: .leading)
                            .foregroundStyle(.black)
                    } else{
                        Text("**** \(currency)")
                            .font(.system(size: 35))
                            .frame(maxWidth: 370, alignment: .leading)
                            .foregroundStyle(.black)
                    }
                    
                    
                    Button {
                        show.toggle()
                    } label: {
                        if show{
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
