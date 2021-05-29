//
//  FinishTrip.swift
//  Move
//
//  Created by Sergiu Corbu on 05.05.2021.
//

import SwiftUI
import MapKit
import CoreLocation

struct FinishTrip: View {
	
	@EnvironmentObject var tripViewModel: TripViewModel
	@State private var tripRegion = CLLocationCoordinate2D(latitude: 46.75618, longitude: 23.5948)
	@State var isLoading: Bool = false
	
	let onFinish: () -> Void
	
    var body: some View {
		VStack(alignment: .leading, spacing: 20) {
			NavigationBar(title: "Trip Summary", color: .darkPurple)
			tripMap
			tripBoundaries
			tripData
			Spacer()
			Buttons.PrimaryButton(text: "Pay with", isLoading: isLoading, enabled: true, isBlackBackground: true, action: { onFinish() })
		} 
		.padding(.horizontal, 24)
		.background(SharedElements.whiteBackground)
    }
	
	var tripBoundaries: some View {
		ZStack {
			RoundedRectangle(cornerRadius: 16)
				.fill(Color.fadePurple)
				.opacity(0.15)
				.padding(.vertical, 10)
				.frame(height: 170)
				.overlay(tripStreets)
		}
	}
	
	var tripMap: some View {
		MapView(centerCoordinate: $tripViewModel.centerCoordinate, locations: tripViewModel.tripLocations)
			.frame(height: 180)
			.clipShape(RoundedRectangle(cornerRadius: 30))
			.padding(.top, 15)
	}
	
	var tripStreets: some View {
		VStack(alignment: .leading) {
			TripReusable.TripLocation(infoText: "From", address: tripViewModel.endTrip.startStreet, spaceBetween: 0.5, expandInline: true)
			TripReusable.TripLocation(infoText: "To", address: tripViewModel.endTrip.endStreet, spaceBetween: 0.5, expandInline: true)
		}
	}
	
	var tripData: some View {
		HStack(spacing: 55) {
			ScooterCardComponents.TripInfo(infoText: "Travel time", imageName: "time-img", time: formatTime(string: tripViewModel.endTrip.duration), fontSize: 16)
			ScooterCardComponents.TripInfo(infoText: "Distance", imageName: "map-img", distance: tripViewModel.endTrip.distance.description, fontSize: 16)
		}
	}

	func initiatePayment() {
		isLoading = true
		let paymentHander = Payment()
		paymentHander.startPayment(price: "12.4") { (success) in
			isLoading = false
			if success { showMessage(message: "Payment done") }
			else { showError(error: "Paymant Failed") }
			DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: { onFinish() })
		}
	}
}
