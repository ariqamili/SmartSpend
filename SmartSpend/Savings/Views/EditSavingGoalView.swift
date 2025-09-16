//
//  EditSavingGoalView.swift
//  SmartSpend
//
//  Created by Refik Jaija on 15.9.25.
//

import SwiftUI

struct EditSavingGoalView: View {
    @EnvironmentObject var userVM: UserViewModel
    @State var newGoal: String = ""
    
    var body: some View {
        VStack{
            Form{
                
            Section("Enter new goal") {
                TextField("Goal: \(userVM.currentUser?.preferred_currency ?? User.Currency.MKD)", text: $newGoal)
                    .keyboardType(.decimalPad)
                    .onChange(of: newGoal) { oldValue, newValue in
                        let filtered = newValue.filter { "0123456789.".contains($0) }
                        if filtered != newValue {
                            newGoal = filtered
                        }
                    }
            }
            
            Button("Save") {
                Task {
                    let request = UpdateUserRequest(monthly_saving_goal: Float(newGoal))
                    await userVM.updateProfile(request)
                    await userVM.fetchUser()
                }
            }
            .frame(maxWidth: .infinity)
            .padding(10)
            .foregroundStyle(.white)
            .listRowBackground(Color.MainColor)

            }
        }
        
    }
}

#Preview {
    EditSavingGoalView()
        .environmentObject(UserViewModel())
}
