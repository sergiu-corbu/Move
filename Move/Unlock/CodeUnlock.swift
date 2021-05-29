//
//  CodeUnlock.swift
//  Move
//
//  Created by Sergiu Corbu on 27.04.2021.
//

import SwiftUI
import Introspect
import CoreLocation

struct CodeUnlock: View {
	@StateObject var unlockViewModel: UnlockViewModel
	@State private var isLoading: Bool = false
	@State var digit: String = ""
	let onClose: () -> Void
	let onFinished: () -> Void
	let unlockMethod: (UnlockType) -> Void

    var body: some View {
		VStack {
			NavigationBar(title: "Unlock scooter", color: .white, backButton: "close", action: { onClose() })
				.padding(.horizontal, 24)
			GeometryReader { geometry in
				ScrollView {
					UnlockScooterComponents.Title(title: "Enter the scooter's\nserial number")
						.padding(.top, geometry.size.height * 0.05)
					UnlockScooterComponents.SubTitle(subTitle: "You can find it on the\nscooter's front panel")
						.padding(.top, geometry.size.height * 0.026)
					HStack {
						ForEach(0..<4) { index in
							DigitField(unlockViewModel: unlockViewModel, digit: digitBinding(index: index), isSelected: index == unlockViewModel.selectedIndex)
						}
					}
					.padding(.top, geometry.size.height * 0.137)
					.padding(.bottom, geometry.size.height * 0.2)
					UnlockScooterComponents.UnlockRow(unlockButton1: Buttons.UnlockOptionButton(text: "QR", action: { unlockMethod(.qr) }), unlockButton2: Buttons.UnlockOptionButton(text: "NFC", action: { unlockMethod(.nfc) }))
				}
				.ignoresSafeArea(.keyboard, edges: .bottom)
			}
		}
		.background(SharedElements.purpleBackground)
		.onAppear {
			unlockViewModel.onFinishedUnlock = onFinished
		}
		.onTapGesture {
			hideKeyboard()
		}
	}
	
	func digitBinding(index: Int) -> Binding<String> {
		return Binding<String>.init(get: {
			return String(unlockViewModel.unlockCode[index])
		}) { newValue in
			unlockViewModel.unlockCode[index] = newValue
		}
	}
}

struct DigitField: View {
	
	@ObservedObject var unlockViewModel: UnlockViewModel
	@Binding var digit: String
	var isSelected: Bool
	
	var body: some View {
		TextField("", text: $digit)
			.keyboardType(.numberPad)
			.accentColor(.black)
			.autocapitalization(.none)
			.multilineTextAlignment(.center)
			.padding(.horizontal, 5)
			.frame(width: 52, height: 52)
			.background(isSelected || !digit.isEmpty ? Color.white : Color.fadePurple)
			.clipShape(RoundedRectangle(cornerRadius: 18))
			.introspectTextField { textfield in
				textfield.delegate = self.unlockViewModel
				if unlockViewModel.selectedIndex == 0 { textfield.becomeFirstResponder() }
				if isSelected { textfield.becomeFirstResponder() }
			}
	}
}
