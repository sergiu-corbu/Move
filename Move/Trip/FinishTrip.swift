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
	@State var isLoading: Bool = false
	@State var tripRegion: MKCoordinateRegion
	
	let onFinish: () -> Void
	
	var startLocation: TripLocation {
		return TripLocation(coordinates: CLLocationCoordinate2D(latitude: 46.760628, longitude: 23.586817), image: Image("startArrow"))
	}
	
	var endLocation: TripLocation {
		return TripLocation(coordinates: CLLocationCoordinate2D(latitude: 46.756210, longitude: 23.594485), image: Image("endPin"))

	}
	var annotations: [TripLocation] {
		return [startLocation, endLocation]
	}

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
		Map(coordinateRegion: $tripRegion, annotationItems: annotations) { item in
			MapAnnotation(coordinate: item.coordinates) {
				item.image
			}
		}
		.frame(height: 170)
		.clipShape(RoundedRectangle(cornerRadius: 16))
	}
	
	var tripStreets: some View {
		VStack(alignment: .leading) {
			TripReusable.TripLocation(infoText: "From", address: tripViewModel.startStreet, spaceBetween: 0.5, expandInline: true)
				.padding(.top, 10)
			TripReusable.TripLocation(infoText: "To", address: tripViewModel.startStreet, spaceBetween: 0.5, expandInline: true)
				.padding(.bottom, 10)
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
