//
//  FinishTrip.swift
//  Move
//
//  Created by Sergiu Corbu on 05.05.2021.
//

import SwiftUI

struct FinishTrip: View {
	@State private var isLoading: Bool = false
	@ObservedObject var tripViewModel: TripViewModel
	let paymentHander = Payment()
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
							TripReusable.TripLocation(infoText: "From", address: "Str. Avram Iancu nr. 26 Cladirea 2", extraPadding: false, spaceBetween: 0.5, expandInline: true)
							TripReusable.TripLocation(infoText: "To", address: "Gradina Miko", extraPadding: false, spaceBetween: 0.5, expandInline: true)
						}
						Spacer()
					}
				)
		}
	}
	
	var travelData: some View {
		HStack(spacing: 55) {
			ScooterCardComponents.TripInfo(infoText: "Travel time", imageName: "time-img", time: "00:12", fontSize: 16)
			ScooterCardComponents.TripInfo(infoText: "Distance", imageName: "map-img", distance: "\(tripViewModel.ongoingTrip.distance)", fontSize: 16)
		}
	}
	
	private func initiatePayment() {
		self.paymentHander.startPayment { (success) in
			if success { showMessage(message: "Payment done")}
			else { showError(error: "Paymant Failed")}
			DispatchQueue.main.asyncAfter(deadline: .now() + 4, execute: { onFinish() })
		}
	}
}

struct FinishTrip_Previews: PreviewProvider {
    static var previews: some View {
		FinishTrip(tripViewModel: TripViewModel(), onFinish: {})
    }
}
