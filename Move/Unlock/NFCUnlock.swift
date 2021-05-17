//
//  NFCUnlock.swift
//  Move
//
//  Created by Sergiu Corbu on 29.04.2021.
//

import SwiftUI

struct NFCUnlock: View {
	var mapViewModel: MapViewModel
	@State private var animate: Bool = false
	let onClose: () -> Void
	let onFinished: () -> Void
	
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
				NavigationBar(title: "Bring your phone", color: .white, backButton: "close", action: { onClose() })
				UnlockScooterComponents.Title(title: "NFC unlock")
				UnlockScooterComponents.SubTitle(subTitle: "Hold your phone close to the NFC Tag\nlocated on top of the handlebar of\nyour scooter.")
				Spacer()
				ScooterCardComponents.UnlockRow(unlockButton1: Buttons.UnlockOptionButton(text: "QR", action: {}), unlockButton2: Buttons.UnlockOptionButton(text: "123", action: {}))
			}
		}
		.padding(.horizontal, 24)
		.background(SharedElements.purpleBackground)
	}
}

struct NFCUnlock_Previews: PreviewProvider {
	static var previews: some View {
		NFCUnlock(mapViewModel: MapViewModel(), onClose: {}, onFinished: {})
	}
}
