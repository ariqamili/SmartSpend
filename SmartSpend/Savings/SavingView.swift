//
//  SavingView.swift
//  SmartSpend
//
//  Created by shortcut mac on 26.8.25.
//

import SwiftUI

struct SavingView: View {
    var body: some View {
        VStack{
            SavingGoalRectangle()
            .padding()
            Spacer()
        }
        .navigationTitle(LocalizedStringKey("Saving"))
        .navigationBarTitleDisplayMode(.inline)
//        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    SavingView()
}
