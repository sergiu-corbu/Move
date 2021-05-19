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
		VStack {
			UnlockScooterComponents.Title(title: "Unlock\nsuccessful")
				.frame(maxWidth: .infinity)
				.padding(.bottom, 50)
			SharedElements.checkmarkImage
				.padding(.vertical, 50)
			UnlockScooterComponents.SubTitle(subTitle: "Please respect all the driving regulations\nand other participants in traffic while using\nour scooters.")
				.padding(.top, 70)
		}
		.frame(maxHeight: .infinity)
		.background(SharedElements.purpleBackground)
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
