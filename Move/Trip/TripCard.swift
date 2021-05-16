//
//  TripDetail.swift
//  Move
//
//  Created by Sergiu Corbu on 29.04.2021.
//

import SwiftUI

struct TripDetail: View {
	@StateObject var stopWatch: StopWatchViewModel = StopWatchViewModel()
	@State private var isExpanded: Bool = false
	@State private var lockButtonPressed: Bool = false
	@State private var endRidePressed: Bool = false
	var tripViewModel: TripViewModel
	var mapViewModel: MapViewModel
	var scooter: Scooter {
		return mapViewModel.selectedScooter!
	}
	let onEndRide: () -> Void
	
	var body: some View {
		VStack {
			if !isExpanded {
				mainBody
					.gesture(
						DragGesture()
							.onChanged({ _ in
								self.isExpanded = true
							})
					)
			} else {
				expandedBody
					.gesture(
						DragGesture()
							.onChanged({ _ in
								self.isExpanded = false
							})
					)
			}
			tripButtons
		}
		.padding(.horizontal, 24)
		.background(SharedElements.whiteRoundedRectangle)
	}
	
	var mainBody: some View {
		VStack(alignment: .leading, spacing: 10) {
			ScooterElements.topLine.frame(maxWidth: .infinity)
			ScooterElements.CardTitle(text: "Trip Details", semiBold: true)
			ScooterElements.ScooterBattery(batteryImage: scooter.batteryImage, battery: scooter.battery, dimOpacity: true)
				.padding(.vertical, 12)
			HStack(spacing: 55) {
				ScooterElements.TripInfo(infoText: "Travel time", imageName: "time-img", time: stopWatch.tripTime, largeFrame: true)
				ScooterElements.TripInfo(infoText: "Distance", imageName: "map-img", distance: "2.7")
			}
		}
	}
	
	var expandedBody: some View {
		VStack(spacing: 24) {
			NavigationBar(title: "Trip Details", color: .darkPurple, backButton: "chevron-down-img", action: {isExpanded=false})
			ScooterElements.BigCard(infoText: "Battery", imageName: scooter.batteryImage, data: "\(scooter.battery)%")
			ScooterElements.BigCard(infoText: "Travel time", imageName: "time-img", data: stopWatch.tripTime)
			ScooterElements.BigCard(infoText: "Distance", imageName: "map-img", data: "2.7 km")
		}
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
			self.stopWatch.isRunning = false
			tripViewModel.endTrip()
			onEndRide()
		})
	}
}

struct TripDetailView_Previews: PreviewProvider {
	static var previews: some View {
		TripDetail(tripViewModel: TripViewModel(), mapViewModel: MapViewModel(), onEndRide: {})
	}
}
