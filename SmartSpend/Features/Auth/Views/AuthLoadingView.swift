//
//  AuthLoadingView.swift
//  SmartSpend
//
//  Created by shortcut mac on 17.8.25.
//

import SwiftUI

struct AuthLoadingView: View {
    var body: some View {
        VStack(spacing: 12) {
            ProgressView()
            Text("Signing in…").font(.footnote).foregroundColor(.secondary)
        }
        .padding()
    }
}
