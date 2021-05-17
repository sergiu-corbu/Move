//
//  UnlockScooterMethods.swift
//  Move
//
//  Created by Sergiu Corbu on 21.04.2021.
//

import SwiftUI

struct UnlockScooterMethods: View {
	var mapViewModel: MapViewModel
	var scooter: Scooter {
		return mapViewModel.selectedScooter!
	}
	let unlockMethod: (UnlockType) -> Void
    
    var body: some View {
        ZStack(alignment: .top) {
			ZStack {
				VStack(spacing: 20) {
					ScooterCardComponents.CardTitle(text: "You can unlock this scooter\nthrough theese methods:")
					scooterInfo
					unlockButtons
				}.padding(.horizontal, 24)
			}.padding(.top, 24)
			ScooterCardComponents.redTopLine
		}.background(SharedElements.whiteRoundedRectangle)
    }

    private var scooterInfo: some View {
		HStack(alignment: .bottom) {
            VStack(alignment: .leading) {
				ScooterCardComponents.scooterTitle
				ScooterCardComponents.ScooterId.init(id: scooter.id)
				ScooterCardComponents.ScooterBattery(batteryImage: scooter.batteryImage, battery: scooter.battery)
					.padding(.bottom, 10)
				ScooterCardComponents.UnlockMiniButton(image: "bell-img", text: "Ring", showBorder: true)
				ScooterCardComponents.UnlockMiniButton(image: "missing", text: "Missing", showBorder: true)
            }
			ScooterCardComponents.scooterImage
            Spacer()
        }
    }
	
    private var unlockButtons: some View {
        HStack(spacing: 25) {
			Buttons.UnlockButton(text: "NFC", action: { unlockMethod(UnlockType.nfc) })
			Buttons.UnlockButton(text: "QR", action: { unlockMethod(UnlockType.qr) })
			Buttons.UnlockButton(text: "123", action: { unlockMethod(UnlockType.code) })
		}.padding(.vertical)
    }
}

struct UnlockScooterMethods_Preview: PreviewProvider {
    static var previews: some View {
		UnlockScooterMethods(mapViewModel: MapViewModel(), unlockMethod: { _ in })
    }
}
