//
//  ScootersRow.swift
//  Move
//
//  Created by Sergiu Corbu on 11.05.2021.
//

import SwiftUI
import SwiftUIPager

struct ScootersRow: View {
	let scooterList: [Scooter]
	//@StateObject var page: Page = .first()
    var body: some View {
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
}

struct ScootersRowView_Previews: PreviewProvider {
    static var previews: some View {
		ScootersRow(scooterList: [Scooter(id: "123", location: Location(coordinates: [0,0], type: ""), available: true, locked: true, deviceKey: "123", battery: 90),
								  Scooter(id: "123", location: Location(coordinates: [0,0], type: ""), available: true, locked: true, deviceKey: "1453", battery: 90),Scooter(id: "12311", location: Location(coordinates: [0,0], type: ""), available: true, locked: true, deviceKey: "23", battery: 90),Scooter(id: "11111", location: Location(coordinates: [0,0], type: ""), available: true, locked: true, deviceKey: "3", battery: 90)])
    }
}
