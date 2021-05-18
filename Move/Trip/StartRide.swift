//
//  StartRide.swift
//  Move
//
//  Created by Sergiu Corbu on 05.05.2021.
//

import SwiftUI

struct StartRide: View {
	@State private var isLoading: Bool = false
	var scooter: Scooter
	let onStartRide: () -> Void
	
	var body: some View {
		VStack {
			ScooterCardComponents.redTopLine.frame(maxWidth: .infinity)
			HStack {
				VStack(alignment: .leading, spacing: 5) {
					ScooterCardComponents.scooterTitle
					ScooterCardComponents.ScooterId(id: scooter.id)
					ScooterCardComponents.ScooterBattery(batteryImage: scooter.batteryImage, battery: scooter.battery, dimOpacity: false).padding(.top, 5)
				}.padding(.top, 30)
				ScooterCardComponents.scooterImage.padding(.trailing, -24)
			}.padding(.top)
			Buttons.PrimaryButton(text: "Start ride", isLoading: isLoading, enabled: true, action: { onStartRide() })
		}
		.padding(.horizontal, 24)
		.background(SharedElements.whiteRoundedRectangle)
	}
}

//struct StartRide_Previews: PreviewProvider {
//    static var previews: some View {
//		StartRide(mapViewModel: MapViewModel(), onStartRide: {})
//    }
//}
