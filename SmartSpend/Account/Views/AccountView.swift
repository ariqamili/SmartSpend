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
    @State private var wiS: Bool = false
    @State private var imdS: Bool = false
    @State private var wpaS: Bool = false
    @State private var hoarU: Bool = false
    @State private var dscF: Bool = false
    @Environment(\.openURL) private var openUrl
    
    func sendEmail(openUrl: OpenURLAction, to email: String = "refikjaija3@gmail.com", subject: String = "Feedback", body: String = "Dear SmarSpend team,") {
        var components = URLComponents()
        components.scheme = "mailto"
        components.path = email
        components.queryItems = [
            URLQueryItem(name: "subject", value: subject),
            URLQueryItem(name: "body", value: body)
        ]
        guard let url = components.url else { return }

        openUrl(url) { accepted in
            if !accepted {
                print("No message sent")
            }
        }
    }
    
    
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
                            await userVM.fetchUser()
                        }
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .tint(Color.MainColor)
                .padding(.top)
                
                
                HStack{
                    
                    Image(systemName: "envelope")
                        .font(.title2)
                        .foregroundStyle(Color.MainColor)
                    
                    Text(" Support")
                        .font(.headline)
                        .foregroundStyle(Color.MainColor)
                    
                    Spacer()
                    
                    Button(action:{
                        sendEmail(openUrl: openUrl)
                    }, label:{
                        Image(systemName:"chevron.right")
                            .font(.headline)
                    })
                    .foregroundColor(.MainColor)
                    .font(.footnote)
                    .padding(.trailing)
                    
              
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .tint(Color.MainColor)
                .padding(.top)
                
                Text("FAQ")
                    .frame(maxWidth:360, alignment: .leading)
                    .padding(.top)
                    .font(.headline)
                    .foregroundStyle(Color.MainColor)
                
                ScrollView{
                    FAQRow(
                        question: "What is SmartSpend?",
                        answer: "SmartSpend helps you track expenses and gain financial insights."
                    )
                    
                    FAQRow(
                        question: "Is my data secure?",
                        answer: "Yes. Tokens are encrypted with IOS Keychain, and no sensitive info is stored in plain text."
                    )
                    
                    FAQRow(
                        question: "What platforms are supported?",
                        answer: "SmartSpend is available on iOS, Android."
                    )
                    
                    FAQRow(
                        question: "How often are exchange rates updated?",
                        answer: "Rates are refreshed multiple times a day to stay accurate."
                    )
                    
                    FAQRow(
                        question: "Does SmartSpend charge fees?",
                        answer: "No fees. SmartSpend is an internship project from the interns at Shortcut Balkans."
                    )
                    
                }
                .frame(height: 235)

                
                
                Spacer()
                
                Button(action: {
                    authVM.signOut()
                }) {
                    HStack {
                        
                        Text("Log Out")
                            .foregroundStyle(.white)
                    }
                    .frame(maxWidth: .infinity, minHeight: 60)
                    .background(Color.LogOutColor)
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

struct FAQRow: View {
    let question: String
    let answer: String

    @State private var isExpanded = false

    var body: some View {
        VStack() {
            
            Divider()
            
            Button(action: { isExpanded.toggle() }) {
                HStack {
                    Text(question)
                        .foregroundStyle(.gray)
                        .padding()
                    Spacer()
                    if isExpanded{
                        Image(systemName:"chevron.up")
                            .foregroundStyle(.gray)

                    }
                    else{
                        Image(systemName:"chevron.down")
                            .foregroundStyle(.gray)

                    }
                }
                .frame(maxWidth: 380, alignment: .leading)
                .listRowSeparator(.visible)
                
                
            }

            if isExpanded {
                Text(answer)
                    .frame(maxWidth: 345, alignment: .leading)
                    .foregroundStyle(Color.MainColor)
            }
            
        }
    }
}

#Preview {
    AccountView()
        .environmentObject(AuthenticationViewModel())
        .environmentObject(UserViewModel())
}

