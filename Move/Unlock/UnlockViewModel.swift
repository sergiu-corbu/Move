//
//  UnlockViewModel.swift
//  Move
//
//  Created by Sergiu Corbu on 27.04.2021.
//

import Foundation
import SwiftUI
import UIKit

class UnlockViewModel: NSObject, ObservableObject, UITextFieldDelegate {
	
	@Published var unlockCode: [String] = ["", "", "", ""]
	@Published var selectedIndex: Int = 0
	
	let scooter: Scooter
	let userCoordinates: [Double]
	var codeString: String = ""
	var onFinishedUnlock: (() -> Void)?
	
	init(scooter: Scooter, coordinates: [Double]) {
		self.scooter = scooter
		self.userCoordinates = coordinates
	}
	
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		textField.text = string
		codeString += string
		if selectedIndex  < 3 { selectedIndex += 1 }
		else {
			textField.resignFirstResponder()
			API.unlockScooterPin(code: codeString, location: userCoordinates) { result in
				switch result {
					case .success:
						self.onFinishedUnlock?()
					case .failure(let error):
						showError(error: error.localizedDescription)
						self.codeString = ""
						self.selectedIndex = 0
						self.unlockCode = ["", "", "", ""]
						textField.becomeFirstResponder()
				}
			}
		}
		textField.sendActions(for: .editingChanged)
		return false
	}
}
