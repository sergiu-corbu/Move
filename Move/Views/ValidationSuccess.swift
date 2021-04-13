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
        HStack{
            Spacer()
            Text("We've succesfully validated your driving license!")
                .foregroundColor(.white)
                .font(.custom(FontManager.BaiJamjuree.bold, size: 34.0))
            Spacer()
        }
        .padding(.top, 70)
    }
    
    var checkMark: some View {
        VStack {
            Image("checkmark-img")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 172, height: 172)
        }
    }
    
    var exploreButton: some View {
        ReusableButton(activeField: .constant(true), text: "Find scooters", action: {
            print("ready for scooters")
        })
        .padding(.bottom, 10)
    }
}

struct ValidationSuccess_Previews: PreviewProvider {
    static var previews: some View {
        ValidationSuccess()
    }
}
