//
//  TripDetailView.swift
//  Move
//
//  Created by Sergiu Corbu on 29.04.2021.
//

import SwiftUI

struct TripDetailView: View {
	let scooter: Scooter
	
    var body: some View {
		ScrollView{
			Spacer()
		ZStack(alignment: .top) {
			ScooterElements.topLine
			mainBody
		}.background(SharedElements.whiteRoundedRectangle)
		}.background(Color.red)
    }
	
	var mainBody: some View {
		VStack(alignment: .leading, spacing: 10) {
			Text("Trip Details")
				.padding(.top, 20)
				.foregroundColor(.darkPurple)
				.font(.custom(FontManager.Primary.semiBold, size: 16))
				.frame(maxWidth: .infinity)
			ScooterElements.ScooterBattery(batteryImage: scooter.batteryImage, battery: scooter.battery, dimOpacity: true).padding(.vertical, 16)
			HStack(spacing: 55) {
				ScooterElements.TripInfo(infoText: "Travel time", imageName: "time-img", time: "00:12")
				ScooterElements.TripInfo(infoText: "Distance", imageName: "map-img", distance: "2.7")
			}
			ScooterElements.tripButtons
		}.padding(.horizontal, 24)
	}
}

struct ExpandedTripDetailView: View {
	let scooter: Scooter
	
	var body: some View {
		VStack(spacing: 24) {
			NavigationBar(title: "Trip Details", color: .darkPurple, backButton: "chevron-down-img", action: {})
			ScooterElements.BigCard(infoText: "Battery", imageName: scooter.batteryImage, data: "\(scooter.battery)%")
			ScooterElements.BigCard(infoText: "Travel time", imageName: "time-img", data: "00:12:56")
			ScooterElements.BigCard(infoText: "Distance", imageName: "map-img", data: "2.7 km")
			ScooterElements.tripButtons
		}.padding(.horizontal, 24)
	}
}

struct TripDetailView_Previews: PreviewProvider {
	static var previews: some View {
		ExpandedTripDetailView(scooter: Scooter(location: Location(coordinates: [20,0], type: "a"), locked: true, available: true, battery: 90, id: "AVSA", deviceKey: "DQFW", addressName: nil))
	}
}
