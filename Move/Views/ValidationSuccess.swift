//
//  ValidationSuccess.swift
//  Move
//
//  Created by Sergiu Corbu on 13.04.2021.
//

import SwiftUI

struct ValidationSuccess: View {
    let onFindScooters: () -> Void
    
    var body: some View {
        VStack {
			SharedElements.checkmarkImage.padding(.top, 70)
			UnlockScooterElements.Title(title: "We've succesfully validated your driving license!")
			Spacer()
			ActionButton(text: "Find scooters", enabled: true, action: { onFindScooters() })
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
