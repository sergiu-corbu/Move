//
//  ValidationSuccess.swift
//  Move
//
//  Created by Sergiu Corbu on 13.04.2021.
//

import SwiftUI

struct ValidationSuccess: View {
	
	@State private var isLoading: Bool = false
	
	let authNavigation: (AuthNavigation) -> Void
    
    var body: some View {
		GeometryReader { geometry in
			VStack {
				SharedElements.checkmarkImage
					.padding(.top, geometry.size.height * 0.1)
				UnlockScooterComponents.Title(title: "We've succesfully validated your driving license!")
				Spacer()
				Buttons.PrimaryButton(text: "Find scooters",isLoading: isLoading, enabled: true, action: {
					isLoading = true
					authNavigation(.openMap)
					isLoading = false
				})
			}
			.multilineTextAlignment(.center)
			.padding(.horizontal, 24)
			.background(SharedElements.purpleBackground)
		}
    }
}
