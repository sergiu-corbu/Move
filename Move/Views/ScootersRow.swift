//
//  ScootersRow.swift
//  Move
//
//  Created by Sergiu Corbu on 11.05.2021.
//

import SwiftUI

struct ScootersRow: View {
	let allScooters: [Scooter]
	
    var body: some View {
		EmptyView()
	}
}

struct ScootersRowView_Previews: PreviewProvider {
    static var previews: some View {
		ScootersRow(allScooters: [Scooter(id: "123", location: Location(coordinates: [0,0], type: ""), available: true, locked: true, deviceKey: "123", battery: 90),
								  Scooter(id: "123", location: Location(coordinates: [0,0], type: ""), available: true, locked: true, deviceKey: "123", battery: 90),Scooter(id: "123", location: Location(coordinates: [0,0], type: ""), available: true, locked: true, deviceKey: "123", battery: 90),Scooter(id: "123", location: Location(coordinates: [0,0], type: ""), available: true, locked: true, deviceKey: "123", battery: 90)])
    }
}
