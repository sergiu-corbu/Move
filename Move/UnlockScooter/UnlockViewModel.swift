//
//  UnlockScooterViewModel.swift
//  Move
//
//  Created by Sergiu Corbu on 27.04.2021.
//

import Foundation

class UnlockViewModel: ObservableObject {
    
    @Published var unlockCode: String = ""
    @Published var currentIndex: Int = 0
    var maxDigits: Int = 4
    @Published var digit: String = "" {
        didSet {
            if digit.count > 1 {
                digit = String(digit.prefix(1))
                self.unlockCode += digit
            }
        }
    }
    @Published var allDigitsCompleted: Bool = false
    
    
}
