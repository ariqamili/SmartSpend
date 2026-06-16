//
//  HomeViewModel.swift
//  SmartSpend
//
//  Created by Refik Jaija on 25.8.25.
//

import Foundation


@MainActor
class HomeViewModel: ObservableObject {
    @Published var show: Bool = true
    
    func toggleVisibility() {
        show.toggle()
    }
    
    
}
