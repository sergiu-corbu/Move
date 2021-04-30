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
        ZStack {
			SharedElements.purpleBackground
            VStack {
				SharedElements.checkmarkImage.padding(.top, 70)
				UnlockScooterElements.Title(title: "We've succesfully validated your driving license!")
                Spacer()
				ActionButton(enabled: true, text: "Find scooters", action: { onFindScooters() })
					.padding(.bottom, 20)
            }
            .multilineTextAlignment(.center)
			.padding(.horizontal, 24)
        }
    }
}

struct ValidationSuccess_Previews: PreviewProvider {
    static var previews: some View {
        ValidationSuccess(onFindScooters: {})
    }
}
