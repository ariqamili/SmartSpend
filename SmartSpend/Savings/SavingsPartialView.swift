//
//  SavingsPartialView.swift
//  SmartSpend
//
//  Created by Refik Jaija on 15.9.25.
//

import SwiftUI

//
//  HomeView.swift
//  SmartSpend
//
//  Created by shortcut mac on 21.8.25.
//

import SwiftUI
//import Charts



struct SavingsPartialView: View {
    @State var goal: CGFloat = 1000
    @State var spent: CGFloat = 200
    var text: String = "View More"
    @State var isOnHomeScreen: Bool = true
    @EnvironmentObject var userVM: UserViewModel
    
    var body: some View {
        VStack{
            VStack(alignment: .leading, spacing: 7) {
                HStack{
                    Text("Saved in August")
                        .padding(.top)
                        .font(.callout)
                        .opacity(0.6)
                        
                    Spacer()
                    
                    if(isOnHomeScreen) {
                        NavigationLink(text) {
                               // SavingView()
                            }
                        .foregroundColor(.MainColor)
                        .font(.footnote)
                        .padding(.top)
                        .padding(.trailing)
                    } else {
                        Button(text){
                            //
                        }
                        .foregroundColor(.MainColor)
                        .font(.footnote)
                        .padding(.top)
                        .padding(.trailing)
                    }
                    
                }
                Text(" \(userVM.currentUser?.preferred_currency ?? User.Currency.MKD) \(spent)")
                    .font(.title)
                    .padding(.top)
                ProgressView(value: spent, total: goal)
                    .accentColor(.MainColor)
                    .scaleEffect(x: 1, y: 5)
                    .frame(width: .infinity)
                    .padding(.bottom)
                    .padding(.trailing)
                    
            }
            .padding(.leading)

            HStack{
                Text("0 \(userVM.currentUser?.preferred_currency ?? User.Currency.MKD)")
                    .font(.caption)
                    .opacity(0.6)
                Spacer()
                Text("Goal: \(Int(goal)) \(userVM.currentUser?.preferred_currency ?? User.Currency.MKD)")
                    .font(.caption)
                    .opacity(0.6)
            }
            .padding(.leading)
            .padding(.trailing)
            .padding(.bottom)
        }
        .background(Color.MainColor.opacity(0.2))
//        .frame(width: 400, height: 170)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .padding(.horizontal)
    }
    
    
}

#Preview {
    NavigationStack{
        SavingsPartialView()
            .environmentObject(UserViewModel())
    }
    
}
//
