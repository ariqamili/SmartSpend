////
////  SwiftUIView.swift
////  SmartSpend
////
////  Created by shortcut mac on 5.9.25.
////
//
//import SwiftUI
//
//struct StartingScreenView: View {
//    var body: some View {
//        VStack {
//            Image("SmartSpendLogo")
//                .resizable()
//                .frame(width: 230, height: 180)
//            Text("SmartSpend")
//                .font(.system(size: 55, weight: .bold))
//                .foregroundStyle(Color.MainColor)
//        }
//        .frame(maxWidth: .infinity, maxHeight: .infinity)
//        .background(Color.sideColor)
//    }
//}
//
//
//#Preview {
//    StartingScreenView()
//}


//
//  SplashScreenView.swift
//  SmartSpend
//

//
//  LaunchScreenView.swift
//  SmartSpend
//
//  Using your existing SwiftUI design as launch screen
//

import SwiftUI
//
//// MARK: - Launch Screen Manager
//class LaunchScreenManager: ObservableObject {
//    @Published var state: LaunchState = .loading
//    
//    enum LaunchState {
//        case loading
//        case finished
//    }
//    
//    init() {
//        // Simulate app loading time
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
//            withAnimation(.easeInOut(duration: 0.5)) {
//                self.state = .finished
//            }
//        }
//    }
//}
//
//// MARK: - Your Enhanced Launch Screen
//struct StartingScreenView: View {
//    @StateObject private var launchManager = LaunchScreenManager()
//    @State private var logoScale: CGFloat = 0.8
//    @State private var logoOpacity: Double = 0.3
//    @State private var textOffset: CGFloat = 50
//    
//    var body: some View {
//        ZStack {
//            // Your original design with enhancements
//            if launchManager.state == .loading {
//                VStack(spacing: 20) {
//                    // Logo with animation
//                    Image("SmartSpendLogo")
//                        .resizable()
//                        .frame(width: 230, height: 180)
//                        .scaleEffect(logoScale)
//                        .opacity(logoOpacity)
//                    
//                    // App name with animation
//                    Text("SmartSpend")
//                        .font(.system(size: 55, weight: .bold))
//                        .foregroundStyle(Color.MainColor)
//                        .opacity(logoOpacity)
//                        .offset(y: textOffset)
//                    
//                    // Optional: Subtle loading indicator
//                    ProgressView()
//                        .progressViewStyle(CircularProgressViewStyle(tint: Color.MainColor))
//                        .scaleEffect(0.8)
//                        .opacity(0.7)
//                        .padding(.top, 30)
//                }
//                .frame(maxWidth: .infinity, maxHeight: .infinity)
//                .background(Color.sideColor)
//                .onAppear {
//                    // Smooth entrance animation
//                    withAnimation(.easeOut(duration: 1.0)) {
//                        logoScale = 1.0
//                        logoOpacity = 1.0
//                        textOffset = 0
//                    }
//                    
//                    // Optional: Subtle breathing effect
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//                        withAnimation(
//                            .easeInOut(duration: 2.0)
//                            .repeatForever(autoreverses: true)
//                        ) {
//                            logoScale = 1.05
//                        }
//                    }
//                }
//                .transition(.opacity)
//                
//            } else {
//                // Transition to main app
//                HomeView()
//                    .transition(.opacity)
//            }
//        }
//    }
//}
//
//#Preview {
//    StartingScreenView()
//}


// MARK: - Alternative: Simple Version (Closer to Your Original)
struct StartingScreenView: View {
    @State private var isActive = false
    @State private var logoScale: CGFloat = 0.9
    
    var body: some View {
        if isActive {
            HomeView()
        } else {
            VStack {
                Image("SmartSpendLogo")
                    .resizable()
                    .frame(width: 230, height: 180)
                    .scaleEffect(logoScale)
                
                Text("SmartSpend")
                    .font(.system(size: 55, weight: .bold))
                    .foregroundStyle(Color.MainColor)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.sideColor)
            .onAppear {
                // Simple scale animation
                withAnimation(.easeInOut(duration: 1.0)) {
                    logoScale = 1.0
                }
                
                // Transition after 2.5 seconds
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    withAnimation(.easeInOut(duration: 0.6)) {
                        isActive = true
                    }
                }
            }
        }
    }
}


#Preview{
    StartingScreenView()
}
