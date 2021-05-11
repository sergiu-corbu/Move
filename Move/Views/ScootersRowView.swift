//
//  ScootersRowView.swift
//  Move
//
//  Created by Sergiu Corbu on 11.05.2021.
//

import SwiftUI

struct ScootersRowView: View {
	let allScooters: [Scooter]
	
    var body: some View {
		ScrollView(.horizontal, showsIndicators: false) {
			ForEach(0..<allScooters.count) { index in
				ScooterViewItem(scooter: allScooters[index], isUnlocked: .constant(false))
			}
		}
    }
}

struct ScootersRowView_Previews: PreviewProvider {
    static var previews: some View {
        ScootersRowView(allScooters: [])
    }
}
