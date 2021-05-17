//
//  NFCUnlock.swift
//  Move
//
//  Created by Sergiu Corbu on 29.04.2021.
//

import SwiftUI

struct NFCUnlock: View {
	@State private var animate: Bool = false
	var mapViewModel: MapViewModel
	let onClose: () -> Void
	let onFinished: () -> Void
	
	var body: some View {
		ZStack {
			ZStack {
				Image("logoText")
				ZStack {
					Circle()
						.strokeBorder(Color.white, lineWidth: 0.9)
						.opacity(0.3)
						.clipShape(Circle())
						.frame(width: 353, height: 350)
						.scaleEffect(animate ? 1.5 : 1)
					Circle()
						.strokeBorder(Color.white, lineWidth: 1.8)
						.opacity(0.6)
						.clipShape(Circle())
						.frame(width: 258, height: 258)
						.scaleEffect(animate ? 1.2 : 0.9)
					Circle()
						.strokeBorder(Color.white, lineWidth: 3)
						.opacity(1)
						.clipShape(Circle())
						.frame(width: 172, height: 172)
				}
				.onAppear {
					animate = true
				}
				.animation(Animation.linear(duration: 2).repeatForever(autoreverses: false), value: animate)
			}
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
