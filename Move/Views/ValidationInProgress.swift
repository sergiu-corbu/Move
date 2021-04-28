//
//  ValidationInProgress.swift
//  Move
//
//  Created by Sergiu Corbu on 13.04.2021.
//

import SwiftUI

struct ValidationInProgress: View {
    let onExploreButton: () -> Void
	
    var body: some View {
        VStack {
            Spacer()
            mainText
            secondaryText
            Spacer()
			ActionButton(enabled: true, text: "Explore the app", action: { onExploreButton() }) .padding(.bottom, 20)
        }
        .multilineTextAlignment(.center)
		.padding(.horizontal, 24)
		.background(RegisterElements.purpleBackground)
    }
	
    var mainText: some View {
        Text("We are currently verifying your driving license")
            .foregroundColor(.white)
            .font(.custom(FontManager.Primary.bold, size: 34.0))
            .padding(.bottom, 30)
            .frame(maxWidth: .infinity)
    }
    
    var secondaryText: some View {
        Text("Check back shortly and if everything\n looks good you’ll be riding our scooters in no time.")
            .foregroundColor(.fadePurple)
            .font(.custom(FontManager.Primary.medium, size: 18.0))
            .lineSpacing(5)
            .frame(maxWidth: .infinity)
    }
}

struct ValidationInProgress_Previews: PreviewProvider {
    static var previews: some View {
        ValidationInProgress(onExploreButton: {})
    }
}
