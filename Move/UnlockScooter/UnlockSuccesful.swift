//
//  UnlockSuccesful.swift
//  Move
//
//  Created by Sergiu Corbu on 27.04.2021.
//

import SwiftUI

struct UnlockSuccesful: View {
    var body: some View {
        ZStack {
            Image("rect-background-img")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
            VStack {
                title
                checkMark
                attentionText
                Spacer()
            }
        }
        
    }
    var title: some View {
        Text("Unlock\nsuccessful")
            .font(.custom(FontManager.Primary.bold, size: 32))
            .foregroundColor(.white)
            .multilineTextAlignment(.center)
            .padding(.top, 120)
            
    }
    var attentionText: some View {
        Text("Please respect all the driving regulations\nand other participants in traffic while using\nour scooters.")
            .font(.custom(FontManager.Primary.medium, size: 16))
            .foregroundColor(.white)
            .opacity(0.6)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 24)
            .padding(.top, 50)
    }
    private var checkMark: some View {
        Image("checkmark-img")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 172, height: 172)
            .padding(.top, 100)
    }
}

struct UnlockSuccesful_Previews: PreviewProvider {
    static var previews: some View {
        UnlockSuccesful()
    }
}
