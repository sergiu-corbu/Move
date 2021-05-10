//
//  HistoryView.swift
//  Move
//
//  Created by Sergiu Corbu on 16.04.2021.
//

import SwiftUI

struct HistoryView: View {
	@ObservedObject var tripViewModel: TripViewModel = TripViewModel.shared
    let onBack: () -> Void
	
    var body: some View {
		VStack(spacing: 30) {
			NavigationBar(title: "History", color: .darkPurple, backButton: "chevron-left-purple", action: { onBack() })
			ScrollView(showsIndicators: false) {
				PullToRefresh(coordinateSpace: "pullToRefresh") {
					API.downloadTrips({ result in
						switch result {
							case .success(let trips): tripViewModel.allTrips = trips
							case .failure(let error): print(error)
						}
					})
				}
				ForEach(0..<tripViewModel.allTrips.count, id: \.self) { index in
					TripDetail(trip: tripViewModel.allTrips[index])
				}
			}.coordinateSpace(name: "pullToRefresh")
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

struct TripDetail: View {
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
			TripReusable.TripLocation(infoText: "From", address: trip.startLocation)
			TripReusable.TripLocation(infoText: "To", address: trip.endLocation)
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
		HistoryView(tripViewModel: TripViewModel(), onBack: {})
    }
}
