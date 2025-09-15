//
//  StartingScreenView.swift
//  SmartSpend
//
//  Created by shortcut mac on 5.9.25.
//

import SwiftUI

class LaunchScreenManager: ObservableObject {
    @Published var state: LaunchState = .loading
    
    enum LaunchState {
        case loading
        case finished
    }
    
    init() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            withAnimation(.easeInOut(duration: 0.5)) {
                self.state = .finished
            }
        }
    }
}

struct StartingScreenView: View {
    @StateObject private var launchManager = LaunchScreenManager()
    @State private var logoScale: CGFloat = 0.8
    @State private var logoOpacity: Double = 0.3
    @State private var textOffset: CGFloat = 50
    var switchingView: any View
    
    var body: some View {
        ZStack {
            if launchManager.state == .loading {
                VStack(spacing: 20) {
                    Image("SmartSpendLogo")
                        .resizable()
                        .frame(width: 230, height: 180)
                        .scaleEffect(logoScale)
                        .opacity(logoOpacity)
                   
                    Text("SmartSpend")
                        .font(.system(size: 55, weight: .bold))
                        .foregroundStyle(Color.MainColor)
                        .opacity(logoOpacity)
                        .offset(y: textOffset)
                    
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: Color.MainColor))
                        .scaleEffect(0.8)
                        .opacity(0.7)
                        .padding(.top, 30)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.sideColor)
                .onAppear {
                    withAnimation(.easeOut(duration: 1.0)) {
                        logoScale = 1.0
                        logoOpacity = 1.0
                        textOffset = 0
                    }

                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        withAnimation(
                            .easeInOut(duration: 2.0)
                            .repeatForever(autoreverses: true)
                        ) {
                            logoScale = 1.05
                        }
                    }
                }
                .transition(.opacity)
                
            } else {
                AnyView(switchingView)
//                    .transition(.opacity)
            }
        }
    }
}

#Preview {
    StartingScreenView(switchingView: LoginView())
}
