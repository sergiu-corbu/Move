//
//  ScootersRow.swift
//  Move
//
//  Created by Sergiu Corbu on 11.05.2021.
//

import SwiftUI
//import SwiftUIPager

struct ScootersRow: View {
	let scooterList: [Scooter]
	let onSelectScooter: (Scooter) -> Void
	
	private func getScale(proxy: GeometryProxy) -> CGFloat {
		var scale: CGFloat = 1
		let x = proxy.frame(in: .global).minX
		let diff = abs(x)
		if diff < 130 {
			scale = 1 + (120-diff) / 500
		}
		return scale
	}
	
	var body: some View {
		ScrollView(.horizontal, showsIndicators: false) {
			HStack(spacing: 70) {
				ForEach(0..<scooterList.count) { index in
					GeometryReader { geometry in
						let scale = getScale(proxy: geometry)
						ScooterCard(scooter: scooterList[index], onUnlock: {
							onSelectScooter(scooterList[index])
						})
						.scaleEffect(CGSize(width: scale, height: scale))
						.offset(x: 50, y: 50)
					}
					.frame(width: 220, height: 380)
				}
			}
			.padding(.horizontal, 10)
		}
	}
}
/*
VStack {
Spacer()
//			Pager(page: self.page, data: self.scooters,  id: \.self) { scooter in
//				VStack {
//					Text("Page \(scooter.id)")
//				}
//				.frame(width: 300, height: 200)
//				.background(Color.red)
//				//ScooterCard(scooter: scooter, onUnlock: {})
//			}
//			.horizontal()
//			.alignment(.end)
//			.sensitivity(.high)
//			.itemSpacing(10)
//			.interactive(rotation: true)
//			.interactive(scale: 0.8)
}
.background(Color.fadePurple2)
}
*/
