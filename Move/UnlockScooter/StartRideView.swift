//
//  StartRideView.swift
//  Move
//
//  Created by Sergiu Corbu on 28.04.2021.
//

import SwiftUI

struct StartRideView: View {
	@ObservedObject var unlockViewModel: UnlockViewModel
	let startRide: () -> Void
	let scooter: Scooter
	
	var body: some View {
		VStack(spacing: 10) {
			ScooterElements.topLine.padding(.bottom)
			HStack {
				VStack(alignment: .leading) {
					ScooterElements.scooterTitle
					ScooterElements.ScooterId(id: scooter.id)
					ScooterElements.ScooterBattery(batteryImage: scooter.batteryImage, battery: scooter.battery)
				}
				ScooterElements.scooterImage
			}
			ActionButton(isLoading: unlockViewModel.isLoading, enabled: true, text: "Start ride", action: {
				unlockViewModel.isLoading = true
				DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
					unlockViewModel.isLoading = false
				}
			}).padding(.top)
		}.padding(.horizontal, 24)
	}
}

struct StartRideView_Previews: PreviewProvider {
    static var previews: some View {
		StartRideView(unlockViewModel: UnlockViewModel(), startRide: {}, scooter: Scooter(location: Location(coordinates: [1,2], type: "R"), locked: true, available: true, battery: 90, id: "#ABCS", deviceKey: "sff", addressName: nil))
    }
}
