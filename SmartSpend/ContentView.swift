//
//  ContentView.swift
//  SmartSpend
//
//  Created by shortcut mac on 13.8.25.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authVM: AuthenticationViewModel

    var body: some View {
        if authVM.isSignedIn {
            TabView {
                HomeView()
                    .tabItem {
                        Label("Home", systemImage: "house.fill")
                    }

                AddView()
                    .tabItem {
                        Label("Add", systemImage: "plus.circle.fill")
                    }

                AccountView()
                    .tabItem {
                        Label("Account", systemImage: "person.crop.circle.fill")
                    }
                    
            }
        } else {
            LoginView()
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(AuthenticationViewModel()) // inject for previews
    }
}
