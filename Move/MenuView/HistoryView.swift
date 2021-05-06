//
//  HistoryView.swift
//  Move
//
//  Created by Sergiu Corbu on 16.04.2021.
//

import SwiftUI

struct HistoryView: View {
	
	@ObservedObject var tripViewModel: TripViewModel
    let onBack: () -> Void
	
    var body: some View {
        ScrollView(showsIndicators: false) {
			NavigationBar(title: "History", color: .darkPurple, backButton: "chevron-left-purple", action: { onBack() })
				.padding(.bottom, 40)
			ForEach(0..<tripViewModel.allTrips.count, id: \.self) { index in
				TripDetail(trip: tripViewModel.allTrips[index])
			}
        }
		.onAppear {
			API.downloadTrips({ result in
				switch result {
					case .success(let trips):
						tripViewModel.allTrips = trips
					case .failure(let error):
						print(error)
				}
			})
		}
		.padding(.horizontal, 24)
		.background(Color.white.edgesIgnoringSafeArea(.all))
    }
}

struct TripDetail: View {
	let trip: Trip
	
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
			TripReusable.TripLocation(infoText: "From", address: trip.startTime)
			TripReusable.TripLocation(infoText: "To", address: trip.endTime)
		}
    }
    
    var tripTime: some View {
        VStack(alignment: .leading) {
			TripReusable.TripData(infoText: "Travel time", data: String(trip.path[0][0]), showTime: true)
			TripReusable.TripData(infoText: "Distance", data: String(trip.path[0][1])).padding(.top, 16)
		}
    }
}

//struct HistoryView_Previews: PreviewProvider {
//    static var previews: some View {
//        HistoryView(onBack: {})
//    }
//}
