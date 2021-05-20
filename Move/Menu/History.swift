//
//  History.swift
//  Move
//
//  Created by Sergiu Corbu on 16.04.2021.
//

import SwiftUI
import Introspect

struct History: View {
	
	@EnvironmentObject var tripViewModel: TripViewModel
	@State private var isRefreshing: Bool = false
    let onBack: () -> Void
	
    var body: some View {
		VStack(spacing: 30) {
			NavigationBar(title: "History", color: .darkPurple, backButton: "chevron-left-purple", action: { onBack() })
			ScrollView(showsIndicators: false) {
				//PullToRefresh(coordinateSpace: "pullToRefresh") { tripViewModel.downloadTrips() }
				ForEach(0..<tripViewModel.allTrips.count, id: \.self) { index in
					TripCard(trip: tripViewModel.allTrips[index])
				}
			}
			.introspectScrollView { scrollView in
				scrollView.refreshControl?.beginRefreshing()
			}
			//.coordinateSpace(name: "pullToRefresh")
		}
		.padding(.horizontal, 24)
		.background(Color.white.edgesIgnoringSafeArea(.all))
    }
}

struct PullToRefresh: View {
	@State private var isRefreshing: Bool = false
	let coordinateSpace: String
	let onRefresh: () -> Void

	var body: some View {
		GeometryReader { geometry in
			if (geometry.frame(in: .named(coordinateSpace)).midY > 50) {
				Spacer()
					.onAppear { isRefreshing.toggle() }
			} else if (geometry.frame(in: .named(coordinateSpace)).maxY < 20) {
				Spacer()
					.onAppear { isRefreshing.toggle(); onRefresh() }
			}
			if isRefreshing {
				ProgressView()
					.progressViewStyle(CircularProgressViewStyle(tint: .black))
					.scaleEffect(1.5)
					.frame(maxWidth: .infinity)
			}
		}.padding(.top, -50)
	}
}

struct TripCard: View {
	
	@State var trip: Trip
	
	var body: some View {
		ZStack {
			GeometryReader { geometry in
				RoundedRectangle(cornerRadius: 29)
					.stroke(Color.darkPurple, lineWidth: 1)
					.overlay(
						HStack {
							RoundedRectangle(cornerRadius: 29)
								.fill(Color.fadePurple)
								.opacity(0.15)
								.frame(width: geometry.size.width / 1.55)
							Spacer()
						}
					)
			}
			HStack(alignment: .top) {
				tripBoundaries
				Spacer()
				tripTime
			}.padding(.vertical, 10)
		}.padding(.vertical, 6)
	}
	
	var tripBoundaries: some View {
		VStack(alignment: .leading) {
			TripReusable.TripLocation(infoText: "From", address: trip.startStreet)
			TripReusable.TripLocation(infoText: "To", address: trip.endStreet)
		}
	}
	
	var tripTime: some View {
		VStack(alignment: .leading) {
			TripReusable.TripData(infoText: "Travel time", data: String(trip.duration/60), showTime: true)
			TripReusable.TripData(infoText: "Distance", data: String(trip.distance)).padding(.top, 16)
		}
	}
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
		History(onBack: {})
    }
}
