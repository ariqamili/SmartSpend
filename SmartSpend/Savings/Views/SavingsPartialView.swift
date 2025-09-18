//  SavingsPartialView.swift
//  SmartSpend
//
//  Created by Refik Jaija on 15.9.25.
//
import SwiftUI

struct SavingsPartialView: View {
    
    var text: String = "View More"
    @State var isOnHomeScreen: Bool = true
    @State var showEditSheet: Bool = false
    @EnvironmentObject var userVM: UserViewModel
    @EnvironmentObject var transactionVM: TransactionViewModel
    
    var body: some View {
        @State var goal = userVM.currentUser?.monthly_saving_goal ?? 2000
        @State var saved = transactionVM.netBalance
        
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
                        Button(action:{
                            showEditSheet = true
                        }, label:{
                            Text(text)
                        })
                        .foregroundColor(.MainColor)
                        .font(.footnote)
                        .padding(.top)
                        .padding(.trailing)
                    }
                }
                
                Text("\(userVM.currentUser?.preferred_currency.rawValue ?? "MKD") \(Int(saved))")
                    .font(.title)
                    .padding(.top)
                    
                let safeGoal = max(CGFloat(goal), 1)
                let safeSaved = min(max(saved, 0), safeGoal)

                ProgressView(value: safeSaved, total: safeGoal)
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
