//
//  ScooterViewItem.swift
//  Move
//
//  Created by Sergiu Corbu on 20.04.2021.
//

import SwiftUI

struct ScooterViewItem: View {
    @State private var isUnlocking = false
    let scooter: Scooter
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 29)
                .foregroundColor(.white)
                .border(Color.black)
            VStack {
                Spacer()
                HStack{
                    Image("scooterdetail-img")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                    scooterInfo
                }
                location
                unlockButton
            }
            .padding([.leading, .trailing], 24)
        }.frame(width: 250, height: 315)
    }
    
    var scooterInfo: some View {
        VStack(alignment: .trailing) {
            Text("Scooter")
                .font(.custom(FontManager.Primary.medium, size: 16))
                .opacity(0.6)
            Text("#\(scooter.id)")
                .font(.custom(FontManager.Primary.bold, size: 22))
                .lineLimit(1)
            Text(scooter.batteryPercentage)
                .font(.custom(FontManager.Primary.medium, size: 16))
            HStack {
                Image("bell-img")
                Image("getRoute-img")
            }
        }
        .foregroundColor(.darkPurple)
    }
    
    var unlockButton: some View {
        CallToActionButton(isLoading: isUnlocking, enabled: true, text: "Unlock", action: {
            //api call to unlock
        }).padding(.top)
    }
    
    var location: some View {
        HStack(alignment: .top) {
            Image("pin-img")
            Text("Str.Avram Iancu nr 26 Caldirea 2")
                .foregroundColor(.darkPurple)
                .font(.custom(FontManager.Primary.medium, size: 16))
        }.padding(.top)
    }
}

struct scooterActionButton: View {
    let image: String

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 13)
                .foregroundColor(.white)
            Image(image)
                //.resizable()
        }
        //.shadow(radius: 14)
        .frame(width: 36, height: 36)
    }
}

struct ScooterViewItem_Previews: PreviewProvider {
    static var previews: some View {
        ScooterViewItem(scooter: Scooter(id: "AB23", battery: 0.6, location: Location(coordinates: [32.1, -23.4], type: "Pin")))
    }
}
