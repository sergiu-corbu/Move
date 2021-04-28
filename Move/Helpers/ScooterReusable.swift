//
//  ScooterReusable.swift
//  Move
//
//  Created by Sergiu Corbu on 28.04.2021.
//

import SwiftUI

//MARK: Scooter elements
struct ScooterElements {
	static var topLine: some View {
		RoundedRectangle(cornerRadius: 25.0)
			.fill(Color.coralRed)
			.frame(width: 72, height: 4)
	}
	static var scooterTitle: some View {
		Text("Scooter")
			.font(.custom(FontManager.Primary.medium, size: 16))
			.foregroundColor(.darkPurple)
			.opacity(0.6)
			.padding(.bottom, 2)
	}
	static var scooterImage: some View {
		HStack {
			Spacer()
			Image("scooterCard")
				.resizable()
				.aspectRatio(contentMode: .fill)
				.frame(width: 216, height: 216)
		}
		.padding(.top, -50) // not gooood!!!!!!!!!!!!!!
	}
	
	struct ScooterId: View {
		let id: String
		var body: some View {
			Text("#\(id)")
				.font(.custom(FontManager.Primary.bold, size: 32))
				.foregroundColor(.darkPurple)
		}
	}
	
	struct ScooterBattery: View {
		let batteryImage: String
		let battery: Int
		var body: some View {
			HStack {
				Image(batteryImage)
				Text("\(battery)%")
					.font(.custom(FontManager.Primary.medium, size: 15))
			}
		}
	}
	
	struct UnlockRow: View {
		let unlockButton1: UnlockOptionButton
		let unlockButton2: UnlockOptionButton
		
		var body: some View {
			VStack {
				Text("Alternately you can unlock using")
					.font(.custom(FontManager.Primary.medium, size: 16))
				HStack {
					Spacer()
					unlockButton1
					Text("or")
						.font(.custom(FontManager.Primary.bold, size: 16))
						.padding(.horizontal, 20)
					unlockButton1
					Spacer()
				}.padding(.vertical, 20)
			}.foregroundColor(.white)
		}
	}
}

struct ScooterReusable_Previews: PreviewProvider {
    static var previews: some View {
		EmptyView()
    }
}
