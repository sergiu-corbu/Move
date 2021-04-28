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
            ScooterElements.topLine
        }
        .cornerRadius(29, corners: [.topLeft, .topRight])
        .background(Color.white)
    }
    
    private var mainBody: some View {
        ZStack {
            VStack(spacing: 20) {
                header
                scooterInfo
                unlockButtons
            }
            .padding(.horizontal, 24)
            ScooterElements.ScooterBattery.init(batteryImage: scooter.batteryImage, battery: scooter.battery)
        }
        .padding(.top, 24)
    }
    
    private var header: some View {
        HStack {
            Text("You can unlock this scooter\nthrough theese methods: ")
                .font(.custom(FontManager.Primary.bold, size: 16))
                .foregroundColor(Color.darkPurple)
                .frame(maxWidth: .infinity, maxHeight: 50)
                .multilineTextAlignment(.center)
        }
    }

    private var scooterInfo: some View {
        HStack {
            VStack(alignment: .leading) {
                ScooterElements.scooterTitle
                ScooterElements.ScooterId.init(id: scooter.id)
                ScooterElements.ScooterBattery.init(batteryImage: scooter.batteryImage, battery: scooter.battery)
                HStack {
                    MapActionButton(image: "bell-img", action: {
                        
                    })
                    Text("Ring")
                        .font(.custom(FontManager.Primary.medium, size: 14))
                }
                HStack {
                    MapActionButton(image: "missing", action: {
                        
                    })
                    Text("Missing")
                        .font(.custom(FontManager.Primary.medium, size: 14))
                }
            }
           
            Spacer()
        }
    }
    private var unlockButtons: some View {
        HStack(spacing: 25) {
            UnlockButton(text: "NFC", action: {})
            UnlockButton(text: "QR", action: {})
            UnlockButton(text: "123", action: {})
        }
        .padding(.vertical, 10)
    }
    
}


struct UnlockScooterCard_Preview: PreviewProvider {
    static var previews: some View {
        UnlockScooterCard(scooter: Scooter.init(location: Location(coordinates: [10,2], type: "T"), locked: true, available: true, battery: 65, id: "ABCD", deviceKey: "ewfuhw", addressName: "Strada Plopilor"))
    }
}
