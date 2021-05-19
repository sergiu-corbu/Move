//
//  StartRide.swift
//  Move
//
//  Created by Sergiu Corbu on 05.05.2021.
//

import SwiftUI

struct StartRide: View {
	
	@EnvironmentObject var mapViewModel: MapViewModel
	
	let onStartRide: () -> Void
	
	var body: some View {
		VStack {
			ScooterCardComponents.redTopLine.frame(maxWidth: .infinity)
			HStack {
				VStack(alignment: .leading, spacing: 5) {
					ScooterCardComponents.scooterTitle
					ScooterCardComponents.ScooterId(id: mapViewModel.selectedScooter?.id ?? "")
					ScooterCardComponents.ScooterBattery(batteryImage: mapViewModel.selectedScooter?.batteryImage ?? "", battery: mapViewModel.selectedScooter?.battery ?? 0, dimOpacity: false)
						.padding(.top, 5)
				}
				.padding(.top, 30)
				ScooterCardComponents.scooterImage.padding(.trailing, -24)
			}
			.padding(.top)
			Buttons.PrimaryButton(text: "Start ride", enabled: true, action: { onStartRide() })
				.padding(.bottom, -10)
		}
		.padding(.horizontal, 24)
		.background(SharedElements.whiteRoundedRectangle)
	}
}
