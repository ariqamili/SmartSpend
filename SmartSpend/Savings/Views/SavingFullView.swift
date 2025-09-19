//
//  SavingView.swift
//  SmartSpend
//
//  Created by shortcut mac on 26.8.25.
//

import SwiftUI

struct SavingFullView: View {
    @EnvironmentObject var userVM: UserViewModel
    @EnvironmentObject var transactionVM: TransactionViewModel
    
    var body: some View {
        VStack {
            SavingsPartialView(text: "Edit Goal", isOnHomeScreen: false)
                .padding(.vertical)
            
            HStack {
                createSavingsPreview(type: "Total Income", value: transactionVM.income, image: "arrow.up.forward.app", color: .green)
//                    .padding(.trailing, 30)
                        
                        Image("verticalLine")
                        .resizable()
                        .frame(width: 1, height: 35)
                        .padding(.horizontal, 60)
                        
                createSavingsPreview(type: "Total Expense", value: transactionVM.expenses, image: "arrow.down.forward.square", color: .red)
//                    .padding(.leading, 30)
            }
            .padding(.vertical)
            
            SavingsChart()
            
            Spacer()
        }
        .navigationTitle(LocalizedStringKey("Saving"))
        .navigationBarTitleDisplayMode(.inline)
    }
    
    @ViewBuilder
    func createSavingsPreview(type:String, value: Double, image: String, color: Color) -> some View {
        VStack{
            HStack{
                Image(systemName: image)
                    .resizable()
                    .frame(width: 17, height: 17)
                Text(type)
            }
            Text("\(value, specifier: "%.2f") \(userVM.currentUser?.preferred_currency.rawValue ?? "MKD")")
            .foregroundStyle(color)
            .fontWeight(.bold)
        }
    }
    
    
}

#Preview {
    NavigationStack {
        SavingFullView()
            .environmentObject(UserViewModel())
            .environmentObject(TransactionViewModel())
    }
}
