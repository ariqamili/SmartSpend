//
//  HomeView.swift
//  SmartSpend
//
//  Created by shortcut mac on 21.8.25.
//

import SwiftUI
//import Charts



struct SavingGoalRectangle: View {
    @State var goal: CGFloat = 1000
    @State var spent: CGFloat = 200
    var body: some View {
        VStack{
            
//                            .padding()
//            HStack{
//                Text("MKD 1000")
//                    .font(.title)
//                    .padding(.leading)
////                    .padding(.leading)
//                Spacer()
//            }
//                .padding(.top)
//            ProgressView(value: spent, total: goal)
//                .scaleEffect(x: 1, y: 5)
////                .padding()
//                .frame(width: 300)
//                .padding(.bottom)
            VStack(alignment: .leading, spacing: 15) {
                HStack{
                    Text("Saved in August")
                        .padding(.top)
                        .font(.callout)
                        .opacity(0.6)
                        
                    Spacer()
                    NavigationLink("View More") {
                            SavingView()
                        }
                    .foregroundColor(.MainColor)
                        
                    
                    
                    .font(.footnote)
                    .padding(.top)
                    .padding(.trailing)
                    
                }
                Text("MKD 1000")
                    .font(.title)
                    .padding(.top)
                ProgressView(value: spent, total: goal)
                    .accentColor(.MainColor)
                    .scaleEffect(x: 1, y: 5)
                    .frame(width: 340)
                    .padding(.bottom)
                    
            }
            .padding(.leading)

            HStack{
                Text("Goal: \(Int(goal))")
                    .font(.caption)
                    .opacity(0.6)
                Spacer()
                Text("Spent: \(Int(spent))")
                    .font(.caption)
                    .opacity(0.6)
            }
            .padding(.leading)
            .padding(.trailing)
            .padding(.bottom)
        }
        .background(Color.MainColor.opacity(0.2))
        .frame(width: 370, height: 170)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        
    }
}

#Preview {
    NavigationStack{
        SavingGoalRectangle()
    }
    
}
//
