//
//  QRUnlock.swift
//  Move
//
//  Created by Sergiu Corbu on 27.04.2021.
//

import SwiftUI

struct QRUnlock: View {
	
	@ObservedObject var qrViewModel: QRViewModel = QRViewModel()
	
	let onClose: () -> Void
	let unlockMethod: (UnlockType) -> Void
	
	var body: some View {
		ZStack {
			//camera view
			
			
			VStack {
				NavigationBar(title: "Unlock Scooter", color: .white, flashLight: true, backButton: "close", action: { onClose() }) { /*handle flashlight*/
				}
					.padding(.horizontal, 24)
				UnlockScooterComponents.Title(title: "Scan QR")
					.padding(.top)
				UnlockScooterComponents.SubTitle(subTitle: "You can find it on the\nscooter's front panel", fullOpacity: true)
					.padding(.bottom, 60)
				
				RoundedRectangle(cornerRadius: 18)
					.fill(Color.clear)
					.frame(width: 330, height: 220)
					.padding(.bottom, 60)
				
				UnlockScooterComponents.UnlockRow(unlockButton1: Buttons.UnlockOptionButton(text: "123", action: { unlockMethod(.code) }), unlockButton2: Buttons.UnlockOptionButton(text: "NFC", action: { unlockMethod(.nfc) }))
				Spacer()
			}
		}
		.background(Color.black.ignoresSafeArea())
	}
}

struct ScanQR_Previews: PreviewProvider {
	static var previews: some View {
		QRUnlock(onClose: {}, unlockMethod: { _ in})
	}
}
