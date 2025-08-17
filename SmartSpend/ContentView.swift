//
//  ContentView.swift
//  SmartSpend
//
//  Created by shortcut mac on 13.8.25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("🚀 Welcome to SmartSpend")
                    .font(.title)
                    .fontWeight(.bold)

                NavigationLink("Go to Auth") {
                    AppleAuthView() // <--- your future login screen
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
