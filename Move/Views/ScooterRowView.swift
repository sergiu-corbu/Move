//
//  ScooterRowView.swift
//  Move
//
//  Created by Sergiu Corbu on 21.04.2021.
//

import SwiftUI

struct ScooterRowView: View {

    var scooters: [Scooter]
    var body: some View {
        ScrollView(.horizontal, showsIndicators: true) {
            HStack { //?lazy
                ForEach(scooters) { scooter in
                    ScooterViewItem(scooter: scooter)
                        .padding([.leading, .trailing], 15)
                }
            }
        }
    }
}

struct ScooterRowView_Previews: PreviewProvider {
    static var previews: some View {
        ScooterRowView(scooters: [Scooter(id: "#avb", battery: 0.4, location: Location(coordinates: [12,5], type: "Point")),  Scooter(id: "#avb", battery: 0.4, location: Location(coordinates: [12,5], type: "Point"))] )
    }
}
