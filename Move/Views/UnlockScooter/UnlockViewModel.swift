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
	
	@Published var unlockCode: [String] = ["", "", "", ""]
	@Published var isLoading: Bool = false
	@Published var selectedIndex: Int = 0

	let maxPins: Int = 4
	var codeString: String = ""
	//let onFinishedUnlock: () -> Void
	
//	init(onFinishedUnlock: @escaping ()-> Void){
//		self.onFinishedUnlock = onFinishedUnlock
//	}
	
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		textField.text = string
		codeString += string
		if selectedIndex  < 3 { selectedIndex += 1 }
		else {
			textField.resignFirstResponder()
			API.unlockScooterPin(code: codeString) { result in
				switch result {
					case .success(let result):
						print("\(result)")
						//self.onFinishedUnlock()
					case .failure(let error):
						print("\(error)")
				}
			}
		}
		textField.sendActions(for: .editingChanged)
		return false
	}
}
