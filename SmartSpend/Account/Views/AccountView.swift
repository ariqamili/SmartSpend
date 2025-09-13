//
//  AccountView.swift
//  SmartSpend
//
//  Created by Refik Jaija on 17.8.25.
//

import SwiftUI
    

struct AccountView: View {    
    @EnvironmentObject var authVM: AuthenticationViewModel
    @EnvironmentObject var userVM: UserViewModel
    @State private var selectedCurrency: User.Currency = .MKD

    
    
    var body: some View {
        
        NavigationStack {
            
            VStack{
                
                HStack{
                    
                    AsyncImage(url: URL(string: userVM.currentUser?.avatar_url ?? "")) { phase in
                        switch phase {
                        case .failure:
                            Image(systemName: "person")
                                .resizable()
                                .scaledToFit()
                        case .success(let image):
                            image
                                .resizable()
                        default:
                            ProgressView()
                        }
                    }
                    .frame(width: 56, height: 56)
                    .clipShape(.circle)
                    
                    Text("\(userVM.currentUser?.first_name ?? "firstName") \(userVM.currentUser?.last_name ?? "lastName")")
                        .font(.headline)
                        .padding()
                    
                    
                    Spacer()
                    
                    NavigationLink {
                        EditAccountView()
                            .environmentObject(userVM)
                    } label: {
                        
                        Image(systemName: "pencil")
                            .font(.title)
                            .foregroundStyle(.gray)
                        
                    }
                    
                    
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                
                
                
                
                HStack{
                    
                    Image(systemName: "dollarsign.bank.building")
                        .font(.title)
                        .foregroundStyle(Color.MainColor)
                    
                    Text("Currency")
                        .font(.headline)
                        .foregroundStyle(Color.MainColor)
                    
                    Spacer()
                    
                    Picker("Currency", selection: $selectedCurrency) {
                        ForEach(User.Currency.allCases) { currency in
                            Text(currency.rawValue)
                        }
                    }
                    .pickerStyle(.menu)
                    .onChange(of: selectedCurrency) { oldValue, newValue in
                        Task {
                            let request = UpdateUserRequest(preferred_currency: newValue)
                            await userVM.updateProfile(request)
                        }
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .tint(Color.MainColor)
                .padding(.top)
                
                
                
                
                Spacer()
                
                Button(action: {
                    authVM.signOut()
                }) {
                    HStack {
                        
                        Text("Log Out")
                            .foregroundStyle(.white)
                    }
                    .frame(maxWidth: .infinity, minHeight: 60)
                    .background(Color.red)
                    .cornerRadius(12)
                    .shadow(radius: 2)
                }
                .padding()
                
                
                
                
                
                
            }
            .toolbar() {
                ToolbarItem(placement: .principal) {
                    Text("Profile")
                }
            }
            .task {
                   if let currency = userVM.currentUser?.preferred_currency {
                       selectedCurrency = currency
                   }
               }
            
            
            
            
            
        }
    }
}

#Preview {
    AccountView()
        .environmentObject(AuthenticationViewModel())
        .environmentObject(UserViewModel())
}
