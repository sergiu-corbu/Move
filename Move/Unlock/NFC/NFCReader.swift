//
//  NFCReader.swift
//  Move
//
//  Created by Sergiu Corbu on 21.05.2021.
//

import Foundation
import SwiftUI
import CoreNFC

class NFCReader: NSObject, NFCNDEFReaderSessionDelegate {
	
	//var onFinished: () -> Void
	var session: NFCNDEFReaderSession?
	
	override init() {
		super.init()
		self.session = NFCNDEFReaderSession(delegate: self, queue: DispatchQueue.main, invalidateAfterFirstRead: false)
		session?.begin()
	}
	
	func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
		showError(error: error.localizedDescription)
	}
	
	func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
		for message in messages {
			for record in message.records {
				if let string = String(data: record.payload, encoding: .ascii) {
					let afterEqual = string.firstIndex(of: "=")
					let code = string.index(after: afterEqual!)
					if string[code...] == "sbjelna001" {
						//onFinished?()
						showMessage(message: "Success")
					}
				}
			}
		}
	}
}
