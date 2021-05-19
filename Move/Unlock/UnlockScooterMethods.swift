//
//  UnlockScooterMethods.swift
//  Move
//
//  Created by Sergiu Corbu on 21.04.2021.
//

import SwiftUI

struct UnlockScooterMethods: View {
	
	@EnvironmentObject var mapViewModel: MapViewModel
	let unlockMethod: (UnlockType) -> Void
	
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
		.background(SharedElements.whiteRoundedRectangle)
    }

    private var scooterInfo: some View {
		HStack(alignment: .bottom) {
            VStack(alignment: .leading) {
				ScooterCardComponents.scooterTitle
				ScooterCardComponents.ScooterId.init(id: mapViewModel.selectedScooter?.id ?? "")
				ScooterCardComponents.ScooterBattery(batteryImage: mapViewModel.selectedScooter?.batteryImage ?? "", battery: mapViewModel.selectedScooter?.battery ?? 0)
					.padding(.bottom, 10)
				ScooterCardComponents.UnlockMiniButton(image: "bell-img", text: "Ring", showBorder: true, action: {
					API.pingScooter(scooterKey: mapViewModel.selectedScooter!.id) { result in
						switch result {
							case .success: print("")
							case .failure(let error):
								showError(error: error.localizedDescription)
						}
					}
				})
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
