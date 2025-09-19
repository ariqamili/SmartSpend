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
    
    let saveMonths: [SaveMonth] = [
        .init(date: Date.from(month: 1), savedForMonth: 1200),
        .init(date: Date.from(month: 2), savedForMonth: 2200),
        .init(date: Date.from(month: 3), savedForMonth: 3200),
        .init(date: Date.from(month: 4), savedForMonth: 1700),
        .init(date: Date.from(month: 5), savedForMonth: 600),
        .init(date: Date.from(month: 6), savedForMonth: 900),
        .init(date: Date.from(month: 7), savedForMonth: 1500),
        .init(date: Date.from(month: 8), savedForMonth: 1900),
        .init(date: Date.from(month: 9), savedForMonth: 1100),
        .init(date: Date.from(month: 10), savedForMonth: 1300),
        .init(date: Date.from(month: 11), savedForMonth: 700),
        .init(date: Date.from(month: 12), savedForMonth: 800)
    ]
    var body: some View {
        VStack{
            Chart{
                
                RuleMark(y: .value("Goal", userVM.currentUser?.monthly_saving_goal ?? 2000))
                    .foregroundStyle(Color.red)
                    .lineStyle(StrokeStyle(lineWidth: 1,dash:[5]))
                    .annotation(alignment: .leading){
                        Text("Goal")
                            .foregroundStyle(Color.red)
                    }
                
                ForEach(saveMonths){ saveMonths in
                    BarMark(x: .value("Month", saveMonths.date),
                            y: .value("Saved", saveMonths.savedForMonth)
                    )
                    .foregroundStyle(Color.MainColor.gradient)
                    
                }
            }
            .frame(width: 340 ,height: 180)
            .padding(.top)
            .padding(.top)
        }
    }
}

#Preview {
    SavingsChart()
        .environmentObject(UserViewModel())
        .environmentObject(TransactionViewModel())
}


struct SaveMonth: Identifiable{
    let id = UUID()
    let date: Date
    let savedForMonth: Int
    
}


extension Date{
    static func from(month: Int)->Date {
        let components = DateComponents(month: month)
        return Calendar.current.date(from: components)!
    }
}
