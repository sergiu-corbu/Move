//
//  UnlockSuccesful.swift
//  Move
//
//  Created by Sergiu Corbu on 27.04.2021.
//

import SwiftUI

struct UnlockSuccesful: View {
	let onFinished: () -> Void
	
    var body: some View {
        ZStack {
			SharedElements.purpleBackground
            VStack {
				UnlockScooterComponents.Title(title: "Unlock\nsuccessful")
					.padding(.top, 50)
				Spacer()
				SharedElements.checkmarkImage
					.padding(.bottom, 50)
				UnlockScooterComponents.SubTitle(subTitle: "Please respect all the driving regulations\nand other participants in traffic while using\nour scooters.")
					.padding(.top, 50)
                Spacer()
            }
        }
		.onAppear {
			DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: { onFinished() })
		}
    }
}

struct UnlockSuccesful_Previews: PreviewProvider {
    static var previews: some View {
		UnlockSuccesful(onFinished: {})
    }
}
