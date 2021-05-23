//
//  NFCReader.swift
//  Move
//
//  Created by Sergiu Corbu on 21.05.2021.
//

import Foundation
import CoreNFC

class NFCReader: NSObject, NFCTagReaderSessionDelegate, ObservableObject {
	
	@Published var scannedCode: Data?
	
	func tagReaderSessionDidBecomeActive(_ session: NFCTagReaderSession) {
		//
	}
	
	func tagReaderSession(_ session: NFCTagReaderSession, didInvalidateWithError error: Error) {
		//
	}
	
	func tagReaderSession(_ session: NFCTagReaderSession, didDetect tags: [NFCTag]) {
		guard let firstTag = tags.first else {
			showError(error: "No tags available")
			return
		}
		session.connect(to: firstTag) { (error: Error?) in
			if error != nil {
				session.invalidate(errorMessage: "Connection error. Please try again")
				return
			}
			showMessage(message: "connected to tag")
			switch firstTag {
				case .iso15693(let discoveredTag):
					print("Got a iso 15693 tag", discoveredTag.icManufacturerCode)
					discoveredTag.readSingleBlock(requestFlags: .highDataRate, blockNumber: 1) { result in
						print(result)
						//upload it
					}
				case .iso7816(let discoveredTag):
					print("Got a iso 78693 tag", discoveredTag.initialSelectedAID)
				// handle all cases
				default:
					session.invalidate(errorMessage: "Unsuuported tag")
			}
		}
	}
	
	
	func scan() {
		let session = NFCTagReaderSession(pollingOption: [.iso14443, .iso15693, .iso18092], delegate: self)
		session?.begin()
	}

}
