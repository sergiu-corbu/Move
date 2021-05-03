//
//  UnlockScooterViewModel.swift
//  Move
//
//  Created by Sergiu Corbu on 27.04.2021.
//

import Foundation

class UnlockViewModel: ObservableObject {
    
    @Published var unlockCode: String = ""
	@Published var isLoading: Bool = false
    let maxPins: Int = 4
	
	@Published var digit1: String = ""
	@Published var digit2: String = ""
	@Published var digit3: String = ""
	@Published var digit4: String = ""

	func submitCode() {
		if unlockCode.count == maxPins {
			print(unlockCode)
			//api call to verify
		}
	}

}
