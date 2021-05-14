//
//  StartRide.swift
//  Move
//
//  Created by Sergiu Corbu on 05.05.2021.
//

import SwiftUI

struct StartRide: View {
	let scooter: Scooter
	let onStartRide: (Scooter) -> Void
	
	var body: some View {
		VStack {
			ScooterElements.topLine.frame(maxWidth: .infinity)
			HStack {
				VStack(alignment: .leading, spacing: 5) {
					ScooterElements.scooterTitle
					ScooterElements.ScooterId(id: scooter.id)
					ScooterElements.ScooterBattery(batteryImage: scooter.batteryImage, battery: scooter.battery, dimOpacity: false).padding(.top, 5)
				}.padding(.top, 30)
				ScooterElements.scooterImage.padding(.trailing, -24)
			}.padding(.top)
			ActionButton(text: "Start ride", isLoading: false, enabled: true, action: { onStartRide(scooter) })
		}
		.padding(.horizontal, 24)
		.background(SharedElements.whiteRoundedRectangle)
	}
}

struct StartRide_Previews: PreviewProvider {
    static var previews: some View {
		StartRide(scooter: Scooter(location: Location(coordinates: [10,2], type: "t"), locked: true, available: true, battery: 90, id: "asdd", deviceKey: "fsodjn", addressName: nil), onStartRide: {_ in })
    }
}
