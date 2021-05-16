//
//  UnlockScooterViewModel.swift
//  Move
//
//  Created by Sergiu Corbu on 27.04.2021.
//

import Foundation
import SwiftUI
import UIKit

class UnlockViewModel: NSObject, ObservableObject, UITextFieldDelegate {
	@ObservedObject var mapViewModel: MapViewModel = MapViewModel.shared
	@Published var unlockCode: [String] = ["", "", "", ""]
	@Published var selectedIndex: Int = 0

	let maxPins: Int = 4
	var codeString: String = ""
	var onFinishedUnlock: (() -> Void)?
	
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		textField.text = string
		codeString += string
		if selectedIndex  < 3 { selectedIndex += 1 }
		else {
			textField.resignFirstResponder()
			if let selectedScooter = mapViewModel.selectedScooter {
				API.unlockScooterPin(scooterID: selectedScooter.id, code: codeString) { result in
					switch result {
						case .success: self.onFinishedUnlock?()
						case .failure(let error):
							showError(error: error.localizedDescription)
							self.codeString = ""
							self.selectedIndex = 0
							self.unlockCode = ["", "", "", ""]
							textField.becomeFirstResponder()
					}
				}
			}
		}
		textField.sendActions(for: .editingChanged)
		return false
	}
}
