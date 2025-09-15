//
//  SavingView.swift
//  SmartSpend
//
//  Created by shortcut mac on 26.8.25.
//

import SwiftUI

struct SavingView: View {
    
    enum Savings {
        case income(_ income: Int)
        case expense(_ expense: Int)
    }
    
    var body: some View {
        VStack {
            SavingGoalRectangle(text: "Edit Goal", isOnHomeScreen: false)
                .padding(.vertical)
            
            HStack {
                createSavingsPreview(type: "Total Income", value: 1000, image: "arrow.up.forward.app", color: .green)
//                    .padding(.trailing, 30)
                        
                        Image("verticalLine")
                        .resizable()
                        .frame(width: 1, height: 35)
                        .padding(.horizontal, 60)
                        
                createSavingsPreview(type: "Total Expense", value: 2000, image: "arrow.down.forward.square", color: .red)
//                    .padding(.leading, 30)
            }
            .padding(.vertical)
            
            Spacer()
        }
        .navigationTitle(LocalizedStringKey("Saving"))
        .navigationBarTitleDisplayMode(.inline)
    }
    
    @ViewBuilder
    func createSavingsPreview(type:String, value: Int, image: String, color: Color) -> some View {
        VStack{
            HStack{
                Image(systemName: image)
                    .resizable()
                    .frame(width: 17, height: 17)
                Text(type)
            }
            Text("\(value)MKD")
            .foregroundStyle(color)
            .fontWeight(.bold)
        }
    }
    
    
}

#Preview {
    SavingView()
}
