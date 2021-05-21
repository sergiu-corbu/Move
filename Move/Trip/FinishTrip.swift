//
//  FinishTrip.swift
//  Move
//
//  Created by Sergiu Corbu on 05.05.2021.
//

import SwiftUI
import MapKit

struct FinishTrip: View {
	
	@EnvironmentObject var tripViewModel: TripViewModel
	
	@State var isLoading: Bool = false
	@State var tripRegion: MKCoordinateRegion
	
	let onFinish: () -> Void
	
    var body: some View {
		VStack(alignment: .leading, spacing: 30) {
			NavigationBar(title: "Trip Summary", color: .darkPurple)
			tripMap
			tripBoundaries
			tripData
			Spacer()
			Buttons.PrimaryButton(text: "Pay with", isLoading: isLoading, enabled: true, isBlackBackground: true, action: { initiatePayment() })
		} 
		.padding(.horizontal, 24)
		.background(SharedElements.whiteBackground)
    }
	
	var tripBoundaries: some View {
		ZStack {
			RoundedRectangle(cornerRadius: 16)
				.fill(Color.fadePurple)
				.opacity(0.15)
				.padding(.vertical, 5)
				.frame(height: 140)
				.overlay(tripStreets)
		}
	}
	
	var tripData: some View {
		HStack(spacing: 55) {
			ScooterCardComponents.TripInfo(infoText: "Travel time", imageName: "time-img", time: tripViewModel.currentTripTime.description, fontSize: 16)
			ScooterCardComponents.TripInfo(infoText: "Distance", imageName: "map-img", distance: tripViewModel.currentTripDistance.description, fontSize: 16)
		}
	}
	
	var tripMap: some View {
		Map(coordinateRegion: $tripRegion)//, annotationItems: <#T##RandomAccessCollection#>, annotationContent: <#T##(Identifiable) -> MapAnnotationProtocol#>)
			.frame(height: 170)
			.clipShape(RoundedRectangle(cornerRadius: 16))
	}
	
	var tripStreets: some View {
		HStack {
			VStack(alignment: .leading) {
				TripReusable.TripLocation(infoText: "From", address: tripViewModel.startStreet, spaceBetween: 0.5, expandInline: true)
				TripReusable.TripLocation(infoText: "To", address: tripViewModel.startStreet, spaceBetween: 0.5, expandInline: true)
			}
		}
	}
	
	func initiatePayment() {
		isLoading = true
		let paymentHander = Payment(totalPrice: tripViewModel.price)
		paymentHander.startPayment { (success) in
			isLoading = false
			if success {
				showMessage(message: "Payment done")
			}
			else {
				showError(error: "Paymant Failed")
			}
			DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
				onFinish()
			})
			
		}
	}
}
