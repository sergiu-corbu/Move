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
	let onFinished: () -> Void
	let unlockMethod: (UnlockType) -> Void
	
	var body: some View {
		ZStack {
			ZStack {
				Image("nfcLogo")
				ZStack {
					NFCCircle(animate: $animate, width: 353, height: 353, opacity: 0.3)
					NFCCircle(animate: $animate, width: 258, height: 258, opacity: 0.6)
					NFCCircle(animate: $animate, width: 172, height: 172, opacity: 1, noAnimation: true)
				}
				.onAppear { animate = true }
				.animation(
					Animation
						.spring()
						.speed(0.35)
						.repeatForever(autoreverses: false)
				)
			}
			VStack {
				NavigationBar(title: "Bring your phone", color: .white, backButton: "close", action: { onClose() })
				UnlockScooterComponents.Title(title: "Unlock scooter")
				UnlockScooterComponents.SubTitle(subTitle: "Hold your phone close to the NFC Tag\nlocated on top of the handlebar of\nyour scooter.")
				Spacer()
				UnlockScooterComponents.UnlockRow(unlockButton1: Buttons.UnlockOptionButton(text: "QR", action: { unlockMethod(.qr) }), unlockButton2: Buttons.UnlockOptionButton(text: "123", action: { unlockMethod(.code) }))
			}
		}
		.padding(.horizontal, 24)
		.background(SharedElements.purpleBackground)
	}
}

struct NFCCircle: View {
	
	@Binding var animate: Bool
	let width: CGFloat
	let height: CGFloat
	let opacity: Double
	var noAnimation: Bool = false
	
	var body: some View {
		Circle()
			.strokeBorder(Color.white, lineWidth: CGFloat(opacity*3))
			.opacity(opacity)
			.clipShape(Circle())
			.frame(width: width, height: height)
			.scaleEffect(noAnimation ? 1 : ( animate ? 1.5 : 1))
	}
}
