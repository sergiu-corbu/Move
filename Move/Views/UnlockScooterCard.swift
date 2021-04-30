//
//  ScooterCard.swift
//  Move
//
//  Created by Sergiu Corbu on 21.04.2021.
//

import SwiftUI

struct UnlockScooterCard: View {
	let onQR: () -> Void
	let onPin: () -> Void
	let onNFC: () -> Void
	
    let scooter: Scooter
    
    var body: some View {
        ZStack(alignment: .top) {
            mainBody
            ScooterElements.topLine
        }
        .cornerRadius(29, corners: [.topLeft, .topRight])
        .background(Color.white)
    }
    
    private var mainBody: some View {
        ZStack {
            VStack(spacing: 20) {
				ScooterElements.cardTitle
                scooterInfo
                unlockButtons
            }
            .padding(.horizontal, 24)
        }
        .padding(.top, 24)
    }

    private var scooterInfo: some View {
		HStack(alignment: .bottom) {
            VStack(alignment: .leading) {
                ScooterElements.scooterTitle
                ScooterElements.ScooterId.init(id: scooter.id)
                ScooterElements.ScooterBattery(batteryImage: scooter.batteryImage, battery: scooter.battery)
				ScooterElements.UnlockScooterMiniButton(image: "bell-img", text: "Ring")
				ScooterElements.UnlockScooterMiniButton(image: "missing", text: "Missing")
            }
			ScooterElements.scooterImage
            Spacer()
        }
    }
	
    private var unlockButtons: some View {
        HStack(spacing: 25) {
            UnlockButton(text: "NFC", action: {onNFC()})
            UnlockButton(text: "QR", action: {onQR()})
            UnlockButton(text: "123", action: {onPin()})
        }.padding(.vertical, 10)
    }
}

struct UnlockScooterCard_Preview: PreviewProvider {
    static var previews: some View {
		UnlockScooterCard(onQR: {}, onPin: {}, onNFC: {}, scooter: Scooter.init(location: Location(coordinates: [10,2], type: "T"), locked: true, available: true, battery: 65, id: "ABCD", deviceKey: "ewfuhw", addressName: "Strada Plopilor"))
    }
}
