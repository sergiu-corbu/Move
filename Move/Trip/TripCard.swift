//
//  TripDetail.swift
//  Move
//
//  Created by Sergiu Corbu on 29.04.2021.
//

import SwiftUI

struct TripDetail: View {

	@ObservedObject var stopWatch: StopWatchViewModel
	@ObservedObject var tripViewModel: TripViewModel
	@EnvironmentObject var mapViewModel: MapViewModel
	@State private var isExpanded: Bool = false
	@State private var lockButtonPressed: Bool = false
	@State private var endRidePressed: Bool = false
	
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
			ScooterCardComponents.ScooterBattery(batteryImage: mapViewModel.selectedScooter?.batteryImage ?? "", battery: mapViewModel.selectedScooter?.battery ?? 0, dimOpacity: true)
				.padding(.vertical, 12)
			HStack(spacing: 60) {
				ScooterCardComponents.TripInfo(infoText: "Travel time", imageName: "time-img", time: stopWatch.tripTime, largeFrame: true)
				ScooterCardComponents.TripInfo(infoText: "Distance", imageName: "map-img", distance: tripViewModel.currentTrip?.distanceString ?? "0")
			}
		}
	}
	
	var expandedBody: some View {
		VStack(spacing: 24) {
			NavigationBar(title: "Trip Details", color: .darkPurple, backButton: "chevron-down-img", action: {isExpanded=false})
			ScooterCardComponents.ExpandedCard(infoText: "Battery", imageName: mapViewModel.selectedScooter?.batteryImage ?? "", data: "\(mapViewModel.selectedScooter?.battery ?? 0)%")
			ScooterCardComponents.ExpandedCard(infoText: "Travel time", imageName: "time-img", data: stopWatch.tripTime)
			ScooterCardComponents.ExpandedCard(infoText: "Distance", imageName: "map-img", data: tripViewModel.currentTrip?.distanceString ?? "0")
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
