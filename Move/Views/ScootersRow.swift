//
//  ScootersRow.swift
//  Move
//
//  Created by Sergiu Corbu on 11.05.2021.
//

import SwiftUI
//import SwiftUIPager

struct ScootersRow: View {
	var scooterList: [Scooter]
	let onSelectScooter: (Scooter) -> Void
	
	private func getScale(proxy: GeometryProxy) -> CGFloat {
		var scale: CGFloat = 0.9
		let x = proxy.frame(in: .global).minX
		let y = proxy.frame(in: .global).minY
		
		if abs(x) < 130 || abs(y) > 130 {
			scale = 0.9 + (130 - abs(x)) / 550
		}
		return scale
	}
	
	var body: some View {
		ScrollView(.horizontal, showsIndicators: false) {
			HStack(spacing: 30) {
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
			.padding(.trailing, 80)
		}
	}
}
