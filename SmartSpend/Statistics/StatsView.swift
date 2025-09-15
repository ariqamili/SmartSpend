//
//  StatsView.swift
//  SmartSpend
//
//  Created by shortcut mac on 9.9.25.
//

import SwiftUI

struct StatsView: View {
    
    @State var selectedView: Int = 1
    
    var body: some View {
        VStack{
            Picker("Period type", selection: $selectedView) {
                Text("Weekly").tag(1)
                Text("Monthly").tag(2)
            }
            .pickerStyle(.segmented)
            .padding()
            
            Spacer()
            
            if(selectedView == 1){
                PieChart(isOnHomeView: false)
            }
            else{
                BarChart()
            }
            
            Spacer()
        }
    }

}

#Preview {
    StatsView()
}
