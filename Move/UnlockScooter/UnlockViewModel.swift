//
//  UnlockScooterViewModel.swift
//  Move
//
//  Created by Sergiu Corbu on 27.04.2021.
//

import Foundation

class UnlockViewModel: ObservableObject {
    
    @Published var enteredDigit: Bool = false
    @Published var unlockCode: String = ""
    //@Published var digits: [
    private let limit: Int = 1
    
}
