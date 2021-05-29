//
//  UnlockMethods.swift
//  Move
//
//  Created by Sergiu Corbu on 21.04.2021.
//

import SwiftUI

struct UnlockMethods: View {
	
	@EnvironmentObject var mapViewModel: MapViewModel
	@State var scooterInRange: Bool = false
	
	let scooter: Scooter
	let unlockMethod: (UnlockType) -> Void
	let onDragDown: () -> Void
	
    var body: some View {
        ZStack(alignment: .top) {
			ZStack {
				VStack(spacing: 20) {
					ScooterCardComponents.CardTitle(text: "You can unlock this scooter\nthrough theese methods:")
					scooterInfo
					unlockButtons
				}
				.padding(.horizontal, 24)
			}
			.padding(.top, 24)
			ScooterCardComponents.redTopLine
		}
		.gesture(
			DragGesture()
				.onChanged({ _ in
					onDragDown()
				})
		)
		.onAppear {
			scooterInRange = mapViewModel.distanceToScooter < 2000 ? true : false
		}
		.background(SharedElements.whiteRoundedRectangle)
    }

    private var scooterInfo: some View {
		HStack(alignment: .bottom) {
            VStack(alignment: .leading) {
				ScooterCardComponents.scooterTitle
				ScooterCardComponents.ScooterId.init(id: scooter.deviceKey)
				ScooterCardComponents.ScooterBattery(batteryImage: scooter.batteryImage, battery: scooter.battery)
					.padding(.bottom, 10)
				ScooterCardComponents.UnlockMiniButton(image: "bell-img", text: "Ring", showBorder: true, action: {
					let location = mapViewModel.userLocation.coordinate
					API.pingScooter(scooterKey: scooter.deviceKey, location: [location.latitude, location.longitude]) { result in
						switch result {
							case .success: print("")
							case .failure(let error):
								showError(error: error.localizedDescription)
						}
					}
				})
				.disabled(!scooterInRange)
				ScooterCardComponents.UnlockMiniButton(image: "missing", text: "Missing", showBorder: true, action: { })
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
		}
		.padding(.vertical)
    }
}
