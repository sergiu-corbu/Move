//
//  ScooterViewItem.swift
//  Move
//
//  Created by Sergiu Corbu on 20.04.2021.
//

import SwiftUI

struct ScooterViewItem: View {
    @State private var isUnlocking = false
    @ObservedObject var mapViewModel: MapViewModel = MapViewModel()
    let scooter: Scooter

    var body: some View {
        ZStack {
            ZStack(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: 29)
                    .foregroundColor(.white)
                RoundedRectangle(cornerRadius: 50)
                    .fill(Color.fadePurple)
                    .frame(width: 140, height: 130)
                    .offset(x: -20, y: -25)
                    .rotationEffect(.degrees(24.0))
                    .opacity(0.15)
                    .clipped()
            }
            VStack {
                Spacer()
                HStack(alignment: .bottom) {
                    Image("scooterdetail-img")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 100, height: 130)
                    scooterInfo
                }
                location
                unlockButton
            }
            .padding([.leading, .trailing], 24)
        }
        .frame(width: 250, height: 315)
        .onAppear {
            mapViewModel.scooterGeocode(location: scooter.location.coordinates)
        }
    }
    
    var scooterInfo: some View {
        
        VStack(alignment: .trailing) {
            Text("Scooter")
                .font(.custom(FontManager.Primary.medium, size: 16))
                .opacity(0.6)
            Text("#\(scooter.id)")
                .font(.custom(FontManager.Primary.bold, size: 22))
                .lineLimit(1)
            HStack {
                Image(scooter.batteryImage)
                Text("\(scooter.battery)%")
                    .font(.custom(FontManager.Primary.medium, size: 16))
            }
            
            HStack {
                MiniActionButton(image: "bell-img", action: {
                    //ring scooter
                }).padding(.trailing, 20)
                MiniActionButton(image: "getRoute-img", action: {
                    //open maps & navigate
                })
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
            Text(mapViewModel.scooterLocation)
                .foregroundColor(.darkPurple)
                .font(.custom(FontManager.Primary.medium, size: 16))
        }.padding(.top)
    }
}

struct ScooterViewItem_Previews: PreviewProvider {
    static var previews: some View {
        ScooterViewItem(scooter: Scooter(id: "AB23", battery: 60, location: Location(coordinates: [32.1, -23.4], type: "Pin")))
    }
}
