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
            Image("rect-background-img")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
            VStack {
                Spacer()
                checkMark
                mainText
                Spacer()
				ActionButton(enabled: true, text: "Find scooters", action: { onFindScooters() })
					.padding(.bottom, 20)
            }
            .multilineTextAlignment(.center)
			.padding(.horizontal, 24)
        }
    }
    
    var mainText: some View {
        Text("We've succesfully validated your driving license!")
            .foregroundColor(.white)
            .font(.custom(FontManager.Primary.bold, size: 34.0))
            .padding(.top, 70)
            .frame(maxWidth: .infinity)
    }
    
    var checkMark: some View {
        Image("checkmark-img")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 172, height: 172)
    }
}

struct ValidationSuccess_Previews: PreviewProvider {
    static var previews: some View {
        ValidationSuccess(onFindScooters: {})
    }
}
