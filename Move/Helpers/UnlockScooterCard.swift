//
//  ScooterCard.swift
//  Move
//
//  Created by Sergiu Corbu on 21.04.2021.
//

import SwiftUI

struct UnlockScooterCard: View {

    let scooter: Scooter
    
    var body: some View {
        ZStack(alignment: .top) {
            mainBody
            topLine
        }
        .cornerRadius(29, corners: [.topLeft, .topRight])
        .background(Color.white)
    }
    
    var mainBody: some View {
        ZStack {
            VStack(spacing: 20) {
                header
                scooterInfo
                unlockButtons
            }
            .padding([.leading, .trailing], 24)
            scooterImage
        }
        .padding(.top, 24)
    }
    
    var header: some View {
        HStack {
            Text("You can unlock this scooter\nthrough theese methods: ")
                .font(.custom(FontManager.Primary.bold, size: 16))
                .foregroundColor(Color.darkPurple)
                .frame(maxWidth: .infinity, maxHeight: 50)
                .multilineTextAlignment(.center)
        }
    }
    var topLine: some View {
        RoundedRectangle(cornerRadius: 25.0)
            .fill(Color.coralRed)
            .frame(width: 72, height: 4)
    }
    var scooterInfo: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Scooter")
                    .font(.custom(FontManager.Primary.medium, size: 16))
                    .opacity(0.6)
                    .padding(.bottom, 2)
                Text("#\(scooter.tag)")
                    .font(.custom(FontManager.Primary.bold, size: 32))
                HStack {
                    Image(scooter.batteryImage)
                    Text("\(scooter.battery)%")
                        .font(.custom(FontManager.Primary.medium, size: 15))
                }
                HStack {
                    MiniActionButton(image: "bell-img", action: {
                        
                    })
                    Text("Ring")
                        .font(.custom(FontManager.Primary.medium, size: 14))
                }
                HStack {
                    MiniActionButton(image: "missing", action: {
                        
                    })
                    Text("Missing")
                        .font(.custom(FontManager.Primary.medium, size: 14))
                }
            }
            .foregroundColor(.darkPurple)
            Spacer()
        }
    }
    var unlockButtons: some View {
        HStack(spacing: 25) {
            UnlockButton(text: "NFC", action: {})
            UnlockButton(text: "QR", action: {})
            UnlockButton(text: "123", action: {})
        }
        .padding(.vertical, 10)
    }
    
    var scooterImage: some View {
        HStack {
            Spacer()
            Image("scooterCard")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 216, height: 216)
        }
        .padding(.top, -50)
    }
}


struct UnlockScooterCard_Preview: PreviewProvider {
    static var previews: some View {
        UnlockScooterCard(scooter: Scooter.init(location: Location(coordinates: [10,2], type: "T"), id: "#ABCD", locked: true, available: true, battery: 65, tag: "ABCD", deviceKey: "ewfuhw", addressName: "Strada Plopilor"))
    }
}
