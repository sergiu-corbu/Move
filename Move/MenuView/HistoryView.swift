//
//  HistoryView.swift
//  Move
//
//  Created by Sergiu Corbu on 16.04.2021.
//

import SwiftUI

struct HistoryView: View {
    let onBack: () -> Void
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            NavigationBar(title: "History", color: .darkPurple, backButton: "chevron-left-purple", action: { onBack() })
            TripDetail() // foreach trip in trips...
        }
		.padding(.horizontal, 24)
		.background(Color.white.edgesIgnoringSafeArea(.all))
    }
}

struct TripDetail: View {
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
        }
    }
    var tripBoundaries: some View {
        VStack(alignment: .leading) {
			TripReusable.TripLocation(infoText: "From", address: "9776 Gutkowski Shores Suite 420")
			TripReusable.TripLocation(infoText: "To", address: "261 Howell Gardhnkjnjj jjjjjjjjjgh")
		}
    }
    
    var tripTime: some View {
        VStack(alignment: .leading) {
			TripReusable.TripData(infoText: "Travel time", data: "00:42", showTime: true)
			TripReusable.TripData(infoText: "Distance", data: "7.8").padding(.top, 16)
		}
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView(onBack: {})
    }
}
