//
//  SNUnlock.swift
//  Move
//
//  Created by Sergiu Corbu on 27.04.2021.
//

import SwiftUI

struct SNUnlock: View {
    let action:() -> Void
    var body: some View {
        ScrollView(showsIndicators: false) {
            NavigationBar(title: "Enter serial number", color: .white, avatar: nil, flashLight: false, backButton: "close", action: { action() })
                .padding(.horizontal, 24)
            title
            subtitle
            UnlockRow(unlockButton1: UnlockOptionButton(text: "QR", action: {}), unlockButton2: UnlockOptionButton(text: "NFC", action: {}))
        }
        .background(
            Image("rect-background-img")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
        )
    }
    var title: some View {
        Text("Enter the scooter's\nserial number")
            .font(.custom(FontManager.Primary.bold, size: 32))
            .foregroundColor(.white)
            .multilineTextAlignment(.center)
            .padding(.bottom, 20)
            .padding(.top, 55)
    }
    var subtitle: some View {
        Text("You can find it on the\nscooter's front panel")
            .font(.custom(FontManager.Primary.medium, size: 16))
            .foregroundColor(.white)
            .opacity(0.6)
            .multilineTextAlignment(.center)
            .lineSpacing(5)
    }
    
}

struct SNUnlock_Previews: PreviewProvider {
    static var previews: some View {
        SNUnlock(action: {})
    }
}
