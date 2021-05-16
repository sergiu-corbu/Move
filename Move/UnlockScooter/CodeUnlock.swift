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
	@ObservedObject var unlockViewModel: UnlockViewModel = UnlockViewModel()
	@State private var isLoading: Bool = false
    let onClose: () -> Void
	let onFinished: () -> Void

    var body: some View {
        ScrollView(showsIndicators: false) {
            NavigationBar(title: "Enter serial number", color: .white, backButton: "close", action: { onClose() })
                .padding(.horizontal, 24)
			UnlockScooterElements.Title(title: "Enter the scooter's\nserial number")
			UnlockScooterElements.SubTitle(subTitle: "You can find it on the\nscooter's front panel").padding(.bottom, 100)
			HStack {
				ForEach(0..<unlockViewModel.maxPins) { index in
					DigitField(unlockViewModel: unlockViewModel, digit: digitBinding(index: index), isSelected: index == unlockViewModel.selectedIndex)
				}
			}
			ScooterElements.UnlockRow(unlockButton1: UnlockOptionButton(text: "QR", action: {}), unlockButton2: UnlockOptionButton(text: "NFC", action: {})).padding(.top, 100)
        }
		.onAppear {
			unlockViewModel.onFinishedUnlock = onFinished
		}
		.onTapGesture { hideKeyboard() }
		.background(SharedElements.purpleBackground)
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
			.multilineTextAlignment(.center)
			.padding(.horizontal, 5)
			.frame(width: 52, height: 52)
			.background(isSelected || !digit.isEmpty ? Color.white : Color.fadePurple)
			.clipShape(RoundedRectangle(cornerRadius: 18))
			.introspectTextField { textfield in
				textfield.delegate = self.unlockViewModel
				if unlockViewModel.selectedIndex == 0 { textfield.becomeFirstResponder() }
				if isSelected { textfield.becomeFirstResponder() }
				if unlockViewModel.selectedIndex == 3 && unlockViewModel.unlockCode[3] != "" { hideKeyboard() }
			}
	}
}
