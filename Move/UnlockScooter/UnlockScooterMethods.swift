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
					ScooterElements.CardTitle(text: "You can unlock this scooter\nthrough theese methods:")
					scooterInfo
					unlockButtons
				}.padding(.horizontal, 24)
			}.padding(.top, 24)
            ScooterElements.topLine
		}.background(SharedElements.whiteRoundedRectangle)
    }

    private var scooterInfo: some View {
		HStack(alignment: .bottom) {
            VStack(alignment: .leading) {
                ScooterElements.scooterTitle
                ScooterElements.ScooterId.init(id: scooter.id)
                ScooterElements.ScooterBattery(batteryImage: scooter.batteryImage, battery: scooter.battery)
					.padding(.bottom, 10)
				ScooterElements.UnlockScooterMiniButton(image: "bell-img", text: "Ring", showBorder: true)
				ScooterElements.UnlockScooterMiniButton(image: "missing", text: "Missing", showBorder: true)
            }
			ScooterElements.scooterImage
            Spacer()
        }
    }
	
    private var unlockButtons: some View {
        HStack(spacing: 25) {
			UnlockButton(text: "NFC", action: { unlockMethod(UnlockType.nfc) })
            UnlockButton(text: "QR", action: { unlockMethod(UnlockType.qr) })
            UnlockButton(text: "123", action: { unlockMethod(UnlockType.code) })
		}.padding(.vertical)
    }
}

struct UnlockScooterMethods_Preview: PreviewProvider {
    static var previews: some View {
		UnlockScooterMethods(mapViewModel: MapViewModel(), unlockMethod: { _ in })
    }
}
