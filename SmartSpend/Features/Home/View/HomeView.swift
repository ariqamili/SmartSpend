//
//  HomeView.swift
//  SmartSpend
//
//  Created by shortcut mac on 21.8.25.
//

import SwiftUI
//import Charts



struct HomeView: View {
    @State var goal: CGFloat = 1000
    @State var spent: CGFloat = 200
    var body: some View {
        //        Chart{
        
        //            BarMark(x: goal, yStart: CGFloat(spent), yEnd: CGFloat(spent + 10), width: 5)
//        ZStack{
        VStack{
            HStack{
                Text("Saved in August")
                    .padding(.top)
                    .padding(.leading)
                    .font(.callout)
                    .opacity(0.6)
                    
                Spacer()
                    NavigationLink("View More") {
                        AuthLoadingView()
                    }
                
                
                .font(.footnote)
                .padding(.top)
                .padding(.trailing)
                
            }
//                            .padding()
            ProgressView(value: spent, total: goal)
                .scaleEffect(x: 1, y: 5.5)
                .padding()
                .frame(width: 300)
                .padding()
            //                .background(Color.gray.opacity(0.2))
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
        .background(.teal.opacity(0.3))
        .frame(width: 320, height: 150)
        .clipShape(RoundedRectangle(cornerRadius: 30))
//        .padding()
        
//    }
            
        
    }
}

#Preview {
    NavigationStack{
        HomeView()
    }
    
}
