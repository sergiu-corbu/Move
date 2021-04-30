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
			.padding(.bottom, 1)
	}
	static var scooterImage: some View {
		HStack {
			Spacer()
			Image("scooterCard")
				.resizable()
				.aspectRatio(contentMode: .fill)
				.frame(width: 200, height: 200)
		}
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
			}.padding(.top, -0.5)
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
					unlockButton2
					Spacer()
				}.padding(.vertical, 20)
			}.foregroundColor(.white)
		}
	}
	
	static var cardTitle: some View {
		Text("You can unlock this scooter\nthrough theese methods: ")
			.font(.custom(FontManager.Primary.bold, size: 16))
			.foregroundColor(Color.darkPurple)
			.frame(maxWidth: .infinity, maxHeight: 50)
			.multilineTextAlignment(.center)
	}
	
	struct UnlockScooterMiniButton: View {
		let image: String
		let text: String
		var body: some View {
			HStack {
				MapActionButton(image: image, action: {})
				Text(text)
					.font(.custom(FontManager.Primary.medium, size: 14))
			}.padding(.leading, -5)
		}
	}
}

struct UnlockScooterElements {
	
	struct Title: View {
		let title: String
		var body: some View {
			Text(title)
				.font(.custom(FontManager.Primary.bold, size: 32))
				.foregroundColor(.white)
				.multilineTextAlignment(.center)
				.padding(.bottom, 20)
				.padding(.top, 35)
		}
	}
	
	struct SubTitle: View {
		let subTitle: String
		var body: some View {
			Text(subTitle)
				.font(.custom(FontManager.Primary.medium, size: 16))
				.foregroundColor(.white)
				.opacity(0.6)
				.multilineTextAlignment(.center)
				.lineSpacing(5)
		}
	}
}

struct ScooterReusable_Previews: PreviewProvider {
    static var previews: some View {
		EmptyView()
    }
}
