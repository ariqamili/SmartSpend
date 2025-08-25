//
//  HomeViewModel.swift
//  SmartSpend
//
//  Created by Refik Jaija on 25.8.25.
//

import Foundation


@MainActor
class HomeViewModel: ObservableObject {
    @Published var currency: String = "MKD"
    @Published var balance: Double = 20000
    @Published var show: Bool = true
    
    func toggleVisibility() {
        show.toggle()
    }
}
