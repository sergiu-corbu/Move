//
//  ScooterCard.swift
//  Move
//
//  Created by Sergiu Corbu on 20.04.2021.
//

import SwiftUI

struct ScooterCard: View {
	
	let scooter: Scooter
	let onUnlock: () -> Void
	
	var body: some View {
		VStack {
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
				Buttons.PrimaryButton(text: "Unlock", isLoading: false, enabled: true, action: { onUnlock() })
			}
			.padding(.horizontal, 24)
		}
		.frame(width: 250, height: 315)
		.clipShape(RoundedRectangle(cornerRadius: 29))
		.padding(.bottom)
		.background(customBackground)
	}
    var scooterInfo: some View {
		VStack(alignment: .trailing, spacing: 7) {
            Text("Scooter")
                .font(.custom(FontManager.Primary.medium, size: 14))
                .opacity(0.6)
			Text("#\(scooter.id)")
                .font(.custom(FontManager.Primary.bold, size: 20))
                .lineLimit(1)
            HStack {
				Image(scooter.batteryImage)
				Text("\(scooter.battery)%")
                    .font(.custom(FontManager.Primary.medium, size: 14))
			}.padding(.bottom, 15)
            HStack {
				Buttons.MapActionButton(image: "bell-img", action: {
//					API.pingScooter(scooterKey: mapViewModel.selectedScooter?.deviceKey ?? "") { result in
//						switch result {
//							case .success(let result):
//								showMessage(message: String(result.ping))
//							case .failure(let error):
//								showError(error: error.localizedDescription)
//						}
//					}
                }).padding(.trailing, 20)
				Buttons.MapActionButton(image: "getRoute-img", action: {
                    //open maps & navigate
                })
            }
        }
		.foregroundColor(.darkPurple)
    }
    
    var location: some View {
        HStack(alignment: .top) {
            Image("pin-img")
			Text("n/a")
                .foregroundColor(.darkPurple)
                .font(.custom(FontManager.Primary.medium, size: 16))
        }.padding(.top)
    }
	
	var customBackground: some View {
		ZStack(alignment: .topLeading) {
			RoundedRectangle(cornerRadius: 29)
				.foregroundColor(.white)
			RoundedRectangle(cornerRadius: 50)
				.fill(Color.fadePurple)
				.frame(width: 140, height: 130)
				.offset(x: -20, y: -25)
				.rotationEffect(.degrees(24.0))
				.opacity(0.15)
				.clipShape(RoundedRectangle(cornerRadius: 29))
		}
	}
}

struct ScooterCard_Previews: PreviewProvider {
    static var previews: some View {
		ScooterCard(scooter: Scooter(id: "asdd", location: Location(coordinates: [10,2], type: "t"), available: true, locked: true, deviceKey: "fsodjn", battery: 90, addressName: nil), onUnlock: {})
    }
}
