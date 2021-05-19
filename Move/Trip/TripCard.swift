//
//  TripDetail.swift
//  Move
//
//  Created by Sergiu Corbu on 29.04.2021.
//

import SwiftUI

struct TripDetail: View {

	@EnvironmentObject var tripViewModel: TripViewModel
	@ObservedObject var stopWatch: StopWatchViewModel
	@State private var buttonPressed: Bool = false
	@State private var isExpanded: Bool = false
	var scooter: Scooter
	
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
		.onAppear {
			tripViewModel.updateTrip()
			print(scooter.id)
			DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
				tripViewModel.updateTrip()
			}
		}
		.padding(.horizontal, 24)
		.background(SharedElements.whiteRoundedRectangle)
	}
	
	var mainBody: some View {
		VStack(alignment: .leading, spacing: 10) {
			ScooterCardComponents.redTopLine.frame(maxWidth: .infinity)
			ScooterCardComponents.CardTitle(text: "Trip Details", semiBold: true)
			ScooterCardComponents.ScooterBattery(batteryImage: scooter.batteryImage, battery: scooter.battery, dimOpacity: true)
				.padding(.vertical, 12)
			HStack(spacing: 60) {
				ScooterCardComponents.TripInfo(infoText: "Travel time", imageName: "time-img", time: stopWatch.tripTime, largeFrame: true)
				ScooterCardComponents.TripInfo(infoText: "Distance", imageName: "map-img", distance: String(tripViewModel.currentTripDistance))
			}
		}
	}
	
	var expandedBody: some View {
		VStack(spacing: 24) {
			NavigationBar(title: "Trip Details", color: .darkPurple, backButton: "chevron-down-img", action: {isExpanded=false})
			ScooterCardComponents.ExpandedCard(infoText: "Battery", imageName: scooter.batteryImage, data: String(scooter.battery)+"%")
			ScooterCardComponents.ExpandedCard(infoText: "Travel time", imageName: "time-img", data: stopWatch.tripTime)
			ScooterCardComponents.ExpandedCard(infoText: "Distance", imageName: "map-img", data: String(tripViewModel.currentTripDistance))
		}
	}
	
	private var tripButtons: some View {
		ScooterCardComponents.TripButtons(isLockedPressed: $buttonPressed, onLockButton: {
			tripViewModel.lockScooter()
			buttonPressed.toggle()
		}, onUnlockButton: {
			tripViewModel.unlockScooter()
			buttonPressed.toggle()
		}, onEndTripButton: {
			self.stopWatch.isRunning = false
			tripViewModel.endTrip()
			onEndRide()
		})
	}
}
