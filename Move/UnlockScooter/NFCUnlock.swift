//
//  NFCUnlock.swift
//  Move
//
//  Created by Sergiu Corbu on 29.04.2021.
//

import SwiftUI

struct NFCUnlock: View {
	@State private var animate: Bool = false
	
	let onClose: () -> Void
	let onQRUnlock: () -> Void
	let onPinUnlock: () -> Void
	let onCompleted: () -> Void
	
	var body: some View {
		ZStack {
			ZStack {
				Image("logoText")
				ZStack {
					SharedElements.NFCCircle(width: 350, height: 350, opacity: 0.3)
					SharedElements.NFCCircle(width: 258, height: 258, opacity: 0.6)
					SharedElements.NFCCircle(width: 172, height: 172, opacity: 1)
				}
			}
			.alignmentGuide(VerticalAlignment.center, computeValue: { dimension in
				dimension[VerticalAlignment.center]
			})
			.alignmentGuide(HorizontalAlignment.center, computeValue: { dimension in
				dimension[HorizontalAlignment.center]
			})
			VStack {
				NavigationBar(title: "Bring your phone", color: .white, avatar: nil, flashLight: false, backButton: "close", action: { onClose() })
				UnlockScooterElements.Title(title: "NFC unlock")
				UnlockScooterElements.SubTitle(subTitle: "Hold your phone close to the NFC Tag\nlocated on top of the handlebar of\nyour scooter.")
				Spacer()
				ScooterElements.UnlockRow(unlockButton1: UnlockOptionButton(text: "QR", action: {}), unlockButton2: UnlockOptionButton(text: "123", action: {}))
			}
		}
		.padding(.horizontal, 24)
		.background(SharedElements.purpleBackground)
	}
}

struct NFCUnlock_Previews: PreviewProvider {
	static var previews: some View {
		NFCUnlock(onClose: {}, onQRUnlock: {}, onPinUnlock: {}, onCompleted: {})
	}
}
/*
extension ZStack {
	func alignInCenter() {
		self
			.alignmentGuide(VerticalAlignment.center, computeValue: { dimension in
				dimension[VerticalAlignment.center]
			})
			.alignmentGuide(HorizontalAlignment.center, computeValue: { dimension in
				dimension[HorizontalAlignment.center]
			})
	}
}
*/
