//
//  TripDetailView.swift
//  Move
//
//  Created by Sergiu Corbu on 29.04.2021.
//

import SwiftUI

struct TripDetailView: View {
	
	@State var tapped: Bool = false
	@State var lockButtonPressed: Bool = false
	@State private var endRidePressed: Bool = false
	@ObservedObject var stopWatch = StopWatch()
	@ObservedObject var tripViewModel = TripViewModel()
	
	let scooter: Scooter
	let onEndRide: () -> Void
	
	var body: some View {
		if tapped { expandedBody }
		else { mainBody }
	}

	var mainBody: some View {
		VStack(alignment: .leading, spacing: 10) {
			ScooterElements.topLine.frame(maxWidth: .infinity)
			Text("Trip Details")
				.padding(.top)
				.foregroundColor(.darkPurple)
				.font(.custom(FontManager.Primary.semiBold, size: 16))
				.frame(maxWidth: .infinity)
			ScooterElements.ScooterBattery(batteryImage: scooter.batteryImage, battery: scooter.battery, dimOpacity: true).padding(.vertical, 16)
			HStack(spacing: 55) {
				ScooterElements.TripInfo(infoText: "Travel time", imageName: "time-img", time: stopWatch.stopWatchTime, largeFrame: true)
				ScooterElements.TripInfo(infoText: "Distance", imageName: "map-img", distance: "2.7")
			}
			tripButtons
		}
		.padding(.horizontal, 24)
		.background(SharedElements.whiteRoundedRectangle)
		.onAppear(perform: { self.stopWatch.start() })
		.onTapGesture { tapped = true }
	}
	
	var expandedBody: some View {
		VStack(spacing: 24) {
			NavigationBar(title: "Trip Details", color: .darkPurple, backButton: "chevron-down-img", action: {})
			ScooterElements.BigCard(infoText: "Battery", imageName: scooter.batteryImage, data: "\(scooter.battery)%")
			ScooterElements.BigCard(infoText: "Travel time", imageName: "time-img", data: "")
			ScooterElements.BigCard(infoText: "Distance", imageName: "map-img", data: "2.7 km")
			tripButtons
		}
		.onTapGesture { tapped = false }
		.padding(.horizontal, 24)
	}
	
	private var tripButtons: some View {
		ScooterElements.TripButtons(isLockedPressed: $lockButtonPressed, onLockButton: {
			tripViewModel.lockScooter()
			lockButtonPressed.toggle()
		}, onUnlockButton: {
			tripViewModel.unlockScooter()
			lockButtonPressed.toggle()
		}, onEndTripButton: {
			endRidePressed = true
			self.stopWatch.stop()
			tripViewModel.endTrip()
			onEndRide()
		})
	}
}

struct TripDetailView_Previews: PreviewProvider {
	static var previews: some View {
		TripDetailView(scooter: Scooter(location: Location(coordinates: [20,0], type: "a"), locked: true, available: true, battery: 90, id: "AVSA", deviceKey: "DQFW", addressName: nil), onEndRide: {})
	}
}
