//
//  ValidationSuccess.swift
//  Move
//
//  Created by Sergiu Corbu on 13.04.2021.
//

import SwiftUI

struct ValidationSuccess: View {
	
	@State private var isLoading: Bool = false
    let onFindScooters: () -> Void
    
    var body: some View {
        VStack {
			SharedElements.checkmarkImage.padding(.top, 70)
			UnlockScooterComponents.Title(title: "We've succesfully validated your driving license!")
			Spacer()
			Buttons.PrimaryButton(text: "Find scooters",isLoading: isLoading, enabled: true, action: {
				isLoading = true
				onFindScooters()
				isLoading = false
			})
        }
		.multilineTextAlignment(.center)
		.padding(.horizontal, 24)
		.background(SharedElements.purpleBackground)
    }
}

struct ValidationSuccess_Previews: PreviewProvider {
    static var previews: some View {
        ValidationSuccess(onFindScooters: {})
    }
}
