//
//  ValidationSuccess.swift
//  Move
//
//  Created by Sergiu Corbu on 13.04.2021.
//

import SwiftUI

struct ValidationSuccess: View {
    
    var body: some View {
        VStack {
            Spacer()
            checkMark
            mainText
            Spacer()
            exploreButton
        }
        .multilineTextAlignment(.center)
        .padding([.leading, .trailing], 24)
        .background(
            Image("rect-background-img")
                .resizable()
                .aspectRatio(contentMode: .fill)
        )
        .edgesIgnoringSafeArea(.all)
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
    
    var exploreButton: some View {
        CallToActionButton(enabled: true, text: "Find scooters", action: {
            
        })
    }
}

struct ValidationSuccess_Previews: PreviewProvider {
    static var previews: some View {
        ValidationSuccess()
    }
}
