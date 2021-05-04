//
//  SNUnlock.swift
//  Move
//
//  Created by Sergiu Corbu on 27.04.2021.
//

import SwiftUI
import Introspect
import CoreLocation

struct SNUnlock: View {
	@ObservedObject var scooterViewModel: ScooterViewModel = ScooterViewModel()
    @ObservedObject var unlockViewModel: UnlockViewModel = UnlockViewModel()
    let onClose: () -> Void
//	let onQR: () -> Void
//	let onNFC: () -> Void
    //let onCompleted: (String) -> Void
    var body: some View {
        ScrollView(showsIndicators: false) {
            NavigationBar(title: "Enter serial number", color: .white, backButton: "close", action: { onClose() })
                .padding(.horizontal, 24)
			UnlockScooterElements.Title(title: "Enter the scooter's\nserial number")
			UnlockScooterElements.SubTitle(subTitle: "You can find it on the\nscooter's front panel").padding(.bottom, 100)
            digitRow
			ScooterElements.UnlockRow(unlockButton1: UnlockOptionButton(text: "QR", action: {}), unlockButton2: UnlockOptionButton(text: "NFC", action: {})).padding(.top, 100)
			Button(action: {
				if unlockViewModel.allDigits {
					API.unlockScooterPin(token: Session.tokenKey!) { result in
						if result == true {
							print("unlock successfull")
						} else { print("errooooooooor")}
					}
				}
			}, label: {
				Text("book scooter")
			})
        }.background(SharedElements.purpleBackground)
    }
    
	var digitRow: some View {
		HStack {
		//ForEach(0..<unlockViewModel.maxPins) { index in
			DigitField(unlockViewModel: unlockViewModel, digit: $unlockViewModel.digit1)
			DigitField(unlockViewModel: unlockViewModel, digit: $unlockViewModel.digit2)
			DigitField(unlockViewModel: unlockViewModel, digit: $unlockViewModel.digit3)
			DigitField(unlockViewModel: unlockViewModel, digit: $unlockViewModel.digit4)
		}
	}

	/* Binding(get: {
	viewModel.unlockPin
	}, set: { newValue in
	viewModel.unlockPin.append(contentsOf: newValue.prefix(1))
	self.submitCode()
	}*/
}

struct DigitField: View {
	
	@ObservedObject var unlockViewModel: UnlockViewModel
	@Binding var digit: String {
		didSet {
			if digit.count > 1 {
				digit = String(digit.prefix(1))
			}
		}
	}

	var body: some View {
		TextField("", text: $digit)
			.keyboardType(.numberPad)
			.frame(width: 52, height: 52)
			// .background(activeField ? Color.white : Color.fadePurple)
			.background(Color.fadePurple)
			.accentColor(.black)
			.multilineTextAlignment(.center)
			.clipShape(RoundedRectangle(cornerRadius: 18))
			.padding(.horizontal, 5)
			.onChange(of: digit, perform: { _ in
				unlockViewModel.unlockCode.append(digit)
			})
			.introspectTextField { textfield in
				if unlockViewModel.unlockCode.count == 4 {
					textfield.resignFirstResponder()
				}
			}
	}
}


struct SNUnlock_Previews: PreviewProvider {
	static var previews: some View {
		SNUnlock(onClose: {})
	}
}
