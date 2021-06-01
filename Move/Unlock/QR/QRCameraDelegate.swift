//
//  QRDelegate.swift
//  Move
//
//  Created by Sergiu Corbu on 19.05.2021.
//

import Foundation
import AVFoundation

class QRCameraDelegate: NSObject, AVCaptureMetadataOutputObjectsDelegate {
	
	var scanInterval: Double = 1
	var lastTime = Date(timeIntervalSince1970: 0)
	var resultCompletion: (String) -> Void = { _ in }
	var mockData: String?
	
	func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
		if metadataObjects.first != nil {
		}
	}
	
	func foundBarcode(_ stringValue: String) {
		let now = Date()
		if now.timeIntervalSince(lastTime) >= scanInterval {
			lastTime = now
			self.resultCompletion(stringValue)
		}
	}
	
	@objc func onSimulateScanning(){
		foundBarcode(mockData ?? "Simulated QR-code result.")
	}
}
