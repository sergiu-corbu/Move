//
//  FinishTrip.swift
//  Move
//
//  Created by Sergiu Corbu on 05.05.2021.
//

import SwiftUI

struct FinishTrip: View {
	
	@EnvironmentObject var tripViewModel: TripViewModel
	@State private var isLoading: Bool = false
	
	let onFinish: () -> Void
	
    var body: some View {
		VStack(alignment: .leading, spacing: 30) {
			NavigationBar(title: "Trip Summary", color: .darkPurple)
			Image("mapDraw").frame(maxWidth: .infinity)
			tripBoundaries
			travelData
			Spacer()
			Buttons.PrimaryButton(text: "Pay with", isLoading: isLoading, enabled: true, isBlackBackground: true, action: { initiatePayment() })
		} 
		.padding(.horizontal, 24)
		.background(Color.white.edgesIgnoringSafeArea(.all))
    }
	
	var tripBoundaries: some View {
		ZStack {
			RoundedRectangle(cornerRadius: 16)
				.fill(Color.fadePurple)
				.opacity(0.15)
				.frame(height: 132)
				.overlay(
					HStack {
						VStack(alignment: .leading) {
							TripReusable.TripLocation(infoText: "From", address: tripViewModel.startStreet, extraPadding: false, spaceBetween: 0.5, expandInline: true)
							TripReusable.TripLocation(infoText: "To", address: tripViewModel.endStreet, extraPadding: false, spaceBetween: 0.5, expandInline: true)
						}
						Spacer()
					}
				)
		}
	}
	
	var travelData: some View {
		HStack(spacing: 55) {
			ScooterCardComponents.TripInfo(infoText: "Travel time", imageName: "time-img", time: tripViewModel.currentTripTime.description, fontSize: 16)
			ScooterCardComponents.TripInfo(infoText: "Distance", imageName: "map-img", distance: tripViewModel.currentTripDistance.description, fontSize: 16)
		}
	}
	
	private func initiatePayment() {
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

struct FinishTrip_Previews: PreviewProvider {
    static var previews: some View {
		FinishTrip(onFinish: {})
    }
}
