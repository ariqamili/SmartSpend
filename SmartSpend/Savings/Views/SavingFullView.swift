//  SavingFullView.swift
//  SmartSpend
//
//  Created by Refik Jaija on 15.9.25.
//
import SwiftUI
import Charts

struct SavingFullView: View {
    @EnvironmentObject var userVM: UserViewModel
    
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
        VStack {
            SavingsPartialView(text: "Edit Goal", isOnHomeScreen: false)
                .padding(.vertical)
            
            HStack {
                createSavingsPreview(type: "Total Income", value: 1000, image: "arrow.up.forward.app", color: .green)
  
                Spacer()
                
                createSavingsPreview(type: "Total Expense", value: 2000, image: "arrow.down.forward.square", color: .red)
            }
            .padding()
            
            Chart{
                
                RuleMark(y: .value("Goal", userVM.currentUser?.monthly_saving_goal ?? 2000))
                    .foregroundStyle(Color.LogOutColor)
                    .lineStyle(StrokeStyle(lineWidth: 1,dash:[5]))
                    .annotation(alignment: .leading){
                        Text("Goal")
                            .foregroundStyle(Color.LogOutColor)
                    }
                
                ForEach(saveMonths){ saveMonths in
                    AreaMark(x: .value("Month", saveMonths.date),
                            y: .value("Saved", saveMonths.savedForMonth)
                    )
                    .foregroundStyle(Color.MainColor.gradient)
                    
                }
            }
            .frame(width: 340 ,height: 180)
            .padding(.top)
            .padding(.top)
            
            Spacer()
        }
        .navigationTitle(LocalizedStringKey("Saving"))
        .navigationBarTitleDisplayMode(.inline)
    }
    
    @ViewBuilder
    func createSavingsPreview(type: String, value: Int, image: String, color: Color) -> some View {
        VStack{
            HStack{
                Image(systemName: image)
                    .resizable()
                    .frame(width: 17, height: 17)
                Text(type)
            }
            Text("\(value) \(userVM.currentUser?.preferred_currency.rawValue ?? "MKD")")
                .foregroundStyle(color)
                .fontWeight(.bold)
        }
        .frame(maxWidth: 370)
    }
    
    
    
}

#Preview {
    NavigationStack {
        SavingFullView()
            .environmentObject(UserViewModel())
    }
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
