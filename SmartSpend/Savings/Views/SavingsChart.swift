//
//  SavingsChart.swift
//  SmartSpend
//
//  Created by shortcut mac on 19.9.25.
//

import SwiftUI
import Charts


struct SavingsChart: View {
    @EnvironmentObject var userVM: UserViewModel
    @EnvironmentObject var transactionVM: TransactionViewModel
    
    var body: some View {
        VStack {
            Chart {
                RuleMark(y: .value("Goal", userVM.currentUser?.monthly_saving_goal ?? 2000))
                    .foregroundStyle(Color.red)
                    .lineStyle(StrokeStyle(lineWidth: 1, dash: [5]))
                    .annotation(alignment: .leading) {
                        Text("Goal")
                            .foregroundStyle(Color.red)
                    }
                
                ForEach(transactionVM.monthlyBalances) { monthBalance in
                    AreaMark(
                        x: .value("Month", monthBalance.date, unit: .month),
                        y: .value("Saved", monthBalance.balance)
                    )
                    .foregroundStyle(Color.MainColor.gradient)
                }
            }
            .frame(width: 340, height: 180)
            .padding(.top)
        }
        .task {
            await transactionVM.fetchTransactionsNoTime()
        }
    }
}



#Preview {
    SavingsChart()
        .environmentObject(UserViewModel())
        .environmentObject(TransactionViewModel())
}
