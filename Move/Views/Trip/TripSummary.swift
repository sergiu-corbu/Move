//
//  TripSummary.swift
//  Move
//
//  Created by Sergiu Corbu on 05.05.2021.
//

import SwiftUI

struct TripSummary: View {
	@State private var isLoading: Bool = false
	
    var body: some View {
		VStack(alignment: .leading, spacing: 40) {
			NavigationBar(title: "Trip Summary", color: .darkPurple)
			Image("mapDraw")
			tripBoundaries
			travelData
			ActionButton(isLoading: isLoading, enabled: true, isBlackBackground: true, text: "Pay with", action: {})
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
			ScooterElements.TripInfo(infoText: "Travel time", imageName: "time-img", time: "00:12", fontSize: 16)
			ScooterElements.TripInfo(infoText: "Distance", imageName: "map-img", distance: "2.7", fontSize: 16)
		}
	}
	
	var appleLogo: some View {
		Image(systemName: "applelogo").foregroundColor(.white)
	}
}

struct TripSummary_Previews: PreviewProvider {
    static var previews: some View {
        TripSummary()
    }
}
