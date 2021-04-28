//
//  StartRideView.swift
//  Move
//
//  Created by Sergiu Corbu on 28.04.2021.
//

import SwiftUI

struct StartRideView: View {
    var body: some View {
        ZStack(alignment: .top) {
            ScooterElements.topLine
        }
    }
    var mainBody: some View {
        VStack(alignment: .leading) {
            ScooterElements.scooterTitle
        }
    }
    
}

struct StartRideView_Previews: PreviewProvider {
    static var previews: some View {
        StartRideView()
    }
}
