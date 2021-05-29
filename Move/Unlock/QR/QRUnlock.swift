//
//  QRUnlock.swift
//  Move
//
//  Created by Sergiu Corbu on 27.04.2021.
//

import SwiftUI
import AVFoundation
import CodeScanner

struct QRUnlock: View {
	
	@ObservedObject var qrViewModel: QRViewModel = QRViewModel()
	@State private var torchOn: Bool = false
	
	let onClose: () -> Void
	let onFinish: () -> Void
	let unlockMethod: (UnlockType) -> Void
	
	var body: some View {
		ZStack {
			CodeScannerView(codeTypes: [.qr]) { result in
				switch result {
					case .success(let code):
						API.unlockScooterQR(code: code, street: "") { result in
							switch result {
								case .success:
									onFinish()
								case .failure(let error):
									showError(error: error.localizedDescription)
							}
						}
					case .failure(let error):
						showError(error: error.localizedDescription)
				}
			}
			.edgesIgnoringSafeArea(.all)
			VStack {
				NavigationBar(title: "Unlock scooter", color: .white, flashLight: true, backButton: "close", action: { onClose() }) {
					if torchOn {
						torchOn = false
					} else {
						torchOn = true
					}
					switchFlashlight(on: torchOn)
				}
					.padding(.horizontal, 24)
				UnlockScooterComponents.Title(title: "Scan QR", customPadding: true)
				UnlockScooterComponents.SubTitle(subTitle: "You can find it on the\nscooter's front panel", fullOpacity: true)
				RoundedRectangle(cornerRadius: 18)
					.strokeBorder(Color.gray)
					.foregroundColor(.clear)
					.frame(width: 300, height: 190)
					.frame(maxHeight: .infinity)
				UnlockScooterComponents.UnlockRow(unlockButton1: Buttons.UnlockOptionButton(text: "123", action: { unlockMethod(.code) }), unlockButton2: Buttons.UnlockOptionButton(text: "NFC", action: { unlockMethod(.nfc) }))
					
			}
		}.background(Color.black.ignoresSafeArea())
	}
	
	func switchFlashlight(on: Bool) {
		guard let device = AVCaptureDevice.default(for: AVMediaType.video) else {
			return
		}
		if device.hasTorch {
			do {
				try device.lockForConfiguration()
				if device.torchMode == .on {
					device.torchMode = .off
				} else {
					device.torchMode = .on
				}
			} catch {
				showError(error: "Torch unavailable")
			}
		} else {
			showError(error: "Torch Unavailable")
		}
	}
}
