//
//  UnlockSuccesful.swift
//  Move
//
//  Created by Sergiu Corbu on 27.04.2021.
//

import SwiftUI

struct UnlockSuccesful: View {
    var body: some View {
        ZStack {
			RegisterElements.purpleBackground
            VStack {
				UnlockScooterElements.Title(title: "Unlock\nsuccessful")
					.padding(.top, 120)
				Shapes.checkmarkImage
				UnlockScooterElements.SubTitle(subTitle: "Please respect all the driving regulations\nand other participants in traffic while using\nour scooters.")
					.padding(.top, 50)
                Spacer()
            }
        }
    }
}

struct UnlockSuccesful_Previews: PreviewProvider {
    static var previews: some View {
        UnlockSuccesful()
    }
}
