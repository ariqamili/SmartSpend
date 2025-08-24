//
//  SmartSpendNavigationView.swift
//  SmartSpend
//
//  Created by Refik Jaija on 20.8.25.
//

import SwiftUI

struct SmartSpendNavigationView<Content: View>: View {
    let content: Content
     
     init(@ViewBuilder content: () -> Content) {
         self.content = content()
     }
    
    var body: some View {
        NavigationStack {
                  content
                      .toolbar {
                          ToolbarItem(placement: .topBarLeading) {
                              HStack {
                                  Image("SmartSpendLogo")
                                      .resizable()
                                      .frame(width: 50, height: 40)
                                  Text("SmartSpend")
                                      .font(.headline)
                              }
                          }
                          
                          ToolbarItem(placement: .topBarTrailing) {
                              Button {
                                  print("Inbox tapped")
                              } label: {
                                  VStack {
                                      Image(systemName: "tray.fill")
                                          .resizable()
                                          .scaledToFit()
                                          .frame(width: 24, height: 24)
                                          .foregroundStyle(.gray)
                                      Text("Inbox")
                                          .font(.caption)
                                          .foregroundStyle(.gray)
                                  }
                              }
                          }
                      }
              }
    }
}
