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
	@ObservedObject var tripViewModel: TripViewModel
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
			DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
				print("trip updated")
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
			HStack(spacing: 55) {
				ScooterCardComponents.TripInfo(infoText: "Travel time", imageName: "time-img", time: stopWatch.tripTime, largeFrame: true)
				ScooterCardComponents.TripInfo(infoText: "Distance", imageName: "map-img", distance: tripViewModel.ongoingTrip.distanceString)
			}
		}
	}
	
	var expandedBody: some View {
		VStack(spacing: 24) {
			NavigationBar(title: "Trip Details", color: .darkPurple, backButton: "chevron-down-img", action: {isExpanded=false})
			ScooterCardComponents.ExpandedCard(infoText: "Battery", imageName: scooter.batteryImage, data: "\(scooter.battery)%")
			ScooterCardComponents.ExpandedCard(infoText: "Travel time", imageName: "time-img", data: stopWatch.tripTime)
			ScooterCardComponents.ExpandedCard(infoText: "Distance", imageName: "map-img", data: tripViewModel.ongoingTrip.distanceString)
		}
	}
	
	private var tripButtons: some View {
		ScooterCardComponents.TripButtons(isLockedPressed: $lockButtonPressed, onLockButton: {
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
//
//struct TripDetailView_Previews: PreviewProvider {
//	static var previews: some View {
//		TripDetail(tripViewModel: TripViewModel(), mapViewModel: MapViewModel(), onEndRide: {})
//	}
//}
