//
//  UnlockScooterMethods.swift
//  Move
//
//  Created by Sergiu Corbu on 21.04.2021.
//

import SwiftUI
import CoreLocation

struct UnlockScooterMethods: View {
	
	@EnvironmentObject var mapViewModel: MapViewModel
	@State var scooterInRange: Bool = false
	
	let unlockMethod: (UnlockType) -> Void
	let onDragDown: () -> Void
	var userLocation: CLLocation {
		if let location = mapViewModel.locationManager.location {
			return CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
		} else {
			showError(error: "Cannot get user location")
			return CLLocation(latitude: 0.0, longitude: 0.0)
		}
	}
	
	var userCoordinates: [Double] {
		if let location = mapViewModel.locationManager.location {
			return [location.coordinate.latitude, location.coordinate.longitude]
		} else {
			showError(error: "Cannot get user location")
			return [0,0]
		}
	}
	
	var scooterLocation: CLLocation {
		if let scooter = mapViewModel.selectedScooter {
			return CLLocation(latitude: scooter.coordinates.latitude, longitude: scooter.coordinates.longitude)
		} else {
			showError(error: "Cannot get scooter location")
			return CLLocation(latitude: 0.0, longitude: 0.0)
		}
	}
	
	var distance: Double {
		return userLocation.distance(from: scooterLocation)
	}
	
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
			print("Distance to scooter: \(distance)")
			scooterInRange = distance < 40 ? true : false
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
					API.pingScooter(scooterKey: mapViewModel.selectedScooter!.deviceKey, location: userCoordinates) { result in
						switch result {
							case .success(let result):
								showMessage(message: result.ping.description)
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
