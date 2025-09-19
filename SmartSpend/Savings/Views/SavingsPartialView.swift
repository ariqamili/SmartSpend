//
//  HomeView.swift
//  SmartSpend
//
//  Created by shortcut mac on 21.8.25.
//

import SwiftUI

struct SavingsPartialView: View {
    var text: String = "View More"
    @State var isOnHomeScreen: Bool = true
    @State var showEditSheet: Bool = false
    @EnvironmentObject var userVM: UserViewModel
    @EnvironmentObject var transactionVM: TransactionViewModel
    
    var body: some View {
        @State var goal = userVM.currentUser?.monthly_saving_goal ?? 0
        @State var saved = CGFloat(transactionVM.income - transactionVM.expenses)
        
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
                            SavingFullView()
                                .environmentObject(userVM)
                            }
                        .foregroundColor(.MainColor)
                        .font(.footnote)
                        .padding(.top)
                        .padding(.trailing)
                    } else {
                        Button(text){
                            showEditSheet = true
                        }
                        .foregroundColor(.MainColor)
                        .font(.footnote)
                        .padding(.top)
                        .padding(.trailing)
                    }
                    
                }
                Text("\(Int(saved)) \(userVM.currentUser?.preferred_currency.rawValue ?? "MKD")")
                    .font(.title)
                    .padding(.top)
                     
                let goal = max(userVM.currentUser?.monthly_saving_goal ?? 0, 1) // avoid 0 total
                let rawSaved = CGFloat(transactionVM.income - transactionVM.expenses)
                let saved = max(rawSaved, 0) // don’t allow negatives

                
                ProgressView(value: min(saved, CGFloat(goal)), total: CGFloat(goal))
                    .accentColor(.MainColor)
                    .scaleEffect(x: 1, y: 5)
                    .padding(.bottom)
                    .padding(.trailing)
                    
            }
            .padding(.leading)

            HStack{
                Text("0 \(userVM.currentUser?.preferred_currency.rawValue ?? "MKD")")
                    .font(.caption)
                    .opacity(0.6)
                Spacer()
                Text("Goal: \(Int(goal)) \(userVM.currentUser?.preferred_currency.rawValue ?? "MKD")")
                    .font(.caption)
                    .opacity(0.6)
            }
            .padding(.leading)
            .padding(.trailing)
            .padding(.bottom)
        }
        .background(Color.MainColor.opacity(0.2))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .padding(.horizontal)
        .sheet(isPresented: $showEditSheet) {
            EditSavingGoalView()
                .presentationDetents([.fraction(0.3)])

        }
    }
    
    
}

#Preview {
    NavigationStack{
        SavingsPartialView()
            .environmentObject(UserViewModel())
            .environmentObject(TransactionViewModel())
    }
    
}
