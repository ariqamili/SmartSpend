//
//  EditBalanceView.swift
//  SmartSpend
//
//  Created by Refik Jaija on 17.9.25.
//

import SwiftUI

struct EditBalanceView: View {
    @EnvironmentObject var userVM: UserViewModel
    @State var newBalance: String = ""
    
    var body: some View {
        VStack{
            Form{
                
            Section("Enter new balance") {
                TextField("Balance: \(userVM.currentUser?.preferred_currency ?? User.Currency.MKD)" as String, text: $newBalance)
                    .keyboardType(.decimalPad)
                    .onChange(of: newBalance) { oldValue, newValue in
                        let filtered = newValue.filter { "0123456789.".contains($0) }
                        if filtered != newValue {
                            newBalance = filtered
                        }
                    }
            }
            
            Button("Save") {
                Task {
                    let request = UpdateUserRequest(balance: Float(newBalance))
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
    EditBalanceView()
        .environmentObject(UserViewModel())
}
