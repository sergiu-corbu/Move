//
//  ScooterCard.swift
//  Move
//
//  Created by Sergiu Corbu on 20.04.2021.
//

import SwiftUI

struct ScooterCard: View {
	
	@EnvironmentObject var mapViewModel: MapViewModel
	
	@State var scooter: Scooter
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
					.padding(.bottom, -24)
					.padding(.top, -12)
			}
			.padding(.horizontal, 24)
		}
		.frame(width: 240, height: 270)
		.clipShape(RoundedRectangle(cornerRadius: 29))
		.padding(.bottom)
		.background(customBackground)
		.onAppear {
			showScooterLocation()
		}
	}
	
    var scooterInfo: some View {
		VStack(alignment: .trailing, spacing: 7) {
            Text("Scooter")
                .font(.custom(FontManager.Primary.medium, size: 14))
                .opacity(0.6)
			Text("#\(scooter.deviceKey)")
                .font(.custom(FontManager.Primary.bold, size: 20))
                .lineLimit(1)
            HStack {
				Image(scooter.batteryImage)
				Text("\(scooter.battery)%")
                    .font(.custom(FontManager.Primary.medium, size: 14))
			}
			.padding(.bottom, 10)
			HStack(spacing: 10) {
				Buttons.MapActionButton(image: "bell-img", action: {})
				Buttons.MapActionButton(image: "getRoute-img", action: {})
            }
        }
		.foregroundColor(.darkPurple)
    }
    
    var location: some View {
        HStack(alignment: .top) {
            Image("pin-img")
			Text(scooter.addressName)
                .foregroundColor(.darkPurple)
                .font(.custom(FontManager.Primary.medium, size: 16))
        }
		.padding(.top, 10)
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
	
	 func showScooterLocation() {
		let coordinates: [Double] = [scooter.coordinates.latitude, scooter.coordinates.longitude]
		streetGeocode(coordinates: coordinates) { address in
			scooter.addressName = address
		}
	}
}

struct ScooterCard_Previews: PreviewProvider {
    static var previews: some View {
		ScooterCard(scooter: Scooter(id: "asdd", location: Location(coordinates: [10,2], type: "t"), locked: true, deviceKey: "fsodjn", battery: 90, addressName: ""), onUnlock: {})
    }
}
