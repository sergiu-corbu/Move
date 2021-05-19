//
//  QRViewModel.swift
//  Move
//
//  Created by Sergiu Corbu on 18.05.2021.
//

import Foundation

class QRViewModel: ObservableObject {
	
	@Published var flashlightIsOn: Bool = false
	@Published var lastQrCode: String = ""
	
	func onFoundQrCode(code: String) {
		self.lastQrCode = code
	}
}
