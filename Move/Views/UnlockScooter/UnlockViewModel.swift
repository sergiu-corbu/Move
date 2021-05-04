//
//  UnlockScooterViewModel.swift
//  Move
//
//  Created by Sergiu Corbu on 27.04.2021.
//

import Foundation
import UIKit

class UnlockViewModel: NSObject, ObservableObject, UITextFieldDelegate {
	
	@Published var unlockCode: [String] = ["", "", "", ""]
	@Published var isLoading: Bool = false
	@Published var selectedIndex: Int = 0
	
	let maxPins: Int = 4
	var isCodeCompleted: Bool { return codeString != "" }
	var codeString: String { return unlockCode.joined() }
	
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		textField.text = string
		if selectedIndex  < 3 { selectedIndex += 1 }
		else {
			textField.resignFirstResponder()
			//call
		}
		textField.sendActions(for: .editingChanged)
		return false
	}
}
