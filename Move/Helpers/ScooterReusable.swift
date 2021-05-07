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
		var dimOpacity: Bool = false
		var body: some View {
			HStack {
				Image(batteryImage)
				Text("\(battery)%")
					.font(.custom(FontManager.Primary.medium, size: 15))
					.foregroundColor(.darkPurple)
					.opacity(dimOpacity ? 0.6 : 1)
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
		var showBorder: Bool = false
		var body: some View {
			HStack {
				MapActionButton(image: image, border: showBorder, action:{})
				Text(text)
					.font(.custom(FontManager.Primary.medium, size: 14))
			}
			.padding(.leading, -5)
		}
	}
	
	struct EndTripButton: View {
		let endTrip: () -> Void
		
		var body: some View {
			Button(action: { endTrip() }, label: {
				HStack {
					Text("End ride") .foregroundColor(.white) .font(.custom(FontManager.Primary.bold, size: 16))
				}
				.frame(width: 153, height: 56)
				.background(RoundedRectangle(cornerRadius: 16).foregroundColor(.coralRed))
			})
		}
	}
	
	struct ActionTripButton: View {
		let text: String
		let icon: String
		let tripAction: () -> Void
		
		var body: some View {
			Button(action: { tripAction() }, label: {
				HStack { Label(text, image: icon) .foregroundColor(.coralRed) .font(.custom(FontManager.Primary.bold, size: 16)) }
					.frame(width: 153, height: 56)
					.background(RoundedRectangle(cornerRadius: 16).strokeBorder(Color.coralRed, lineWidth: 1.2).foregroundColor(.white))
			})
		}
	}
	
	struct TripInfo: View {
		let infoText: String
		let imageName: String
		var time: String?
		var distance: String?
		var fontSize: CGFloat = 32
		
		var body: some View {
			VStack(alignment: .leading) {
				TripItemLabel(infoText: infoText, imageName: imageName)
				if let time = time {
					HStack(alignment: .bottom) {
						Text("\(time)")
							.font(.custom(FontManager.Primary.bold, size: fontSize))
							.frame(width: 95)
						Text("min")
							.font(.custom(FontManager.Primary.bold, size: 16))
							.padding(.bottom, fontSize == 32 ? 3.5 : 0)
					}
					.padding(.leading, fontSize == 32 ? 0 : 35)
					.padding(.top, -5)
				} else if let distance = distance {
					HStack(alignment: .bottom) {
						Text("\(distance)")
							.font(.custom(FontManager.Primary.bold, size: fontSize))
						Text("km")
							.font(.custom(FontManager.Primary.bold, size: 16))
							.padding(.bottom, fontSize == 32 ? 3.5 : 0)
					}
					.padding(.leading, fontSize == 32 ? 0 : 35)
					.padding(.top, -5)
				}
			}
			.foregroundColor(.darkPurple)
		}
	}
	
	struct TripItemLabel: View {
		let infoText: String
		let imageName: String
		
		var body: some View {
			Label(infoText, image: imageName)
				.font(.custom(FontManager.Primary.medium, size: 16))
				.opacity(0.6)
		}
	}
	
	struct TripButtons: View {
		@Binding var isLockedPressed: Bool
		var onLockButton: () -> Void
		var onUnlockButton: () -> Void
		let onEndTripButton: () -> Void
		
		var body: some View {
			HStack(spacing: 20) {
				ScooterElements.ActionTripButton(text: isLockedPressed ? "Unlock" : "Lock", icon: isLockedPressed ? "unlock-img" : "lock-img", tripAction: { isLockedPressed ? onLockButton() : onUnlockButton() })
				ScooterElements.EndTripButton(endTrip: {onEndTripButton()})
			}.padding(.vertical, 20)
		}
	}
	
	struct BigCard: View {
		let infoText: String
		let imageName: String
		let data: String
		
		var body: some View {
			ZStack {
				GeometryReader { geometry in
					RoundedRectangle(cornerRadius: 29)
						.stroke(Color.lightGray)
				}
				VStack(spacing: 15) {
					ScooterElements.TripItemLabel(infoText: infoText, imageName: imageName)
					Text(data)
						.font(.custom(FontManager.Primary.bold, size: 44))
						.foregroundColor(.darkPurple)
				}
				.padding(.vertical, 40)
			}
		}
	}
}

struct UnlockScooterElements {
	
	struct Title: View {
		let title: String
		var purpleColor: Bool = false
		var customPadding: Bool = false
		var customAlignment: Bool = false
		var body: some View {
			Text(title)
				.font(.custom(FontManager.Primary.bold, size: 32))
				.foregroundColor(purpleColor ? .darkPurple : .white)
				.multilineTextAlignment(customAlignment ? .leading : .center)
				.padding(.bottom, customPadding ? 10 : 20)
				.padding(.top, customPadding ? 10 : 35)
				.fixedSize(horizontal: false, vertical: true)
		}
	}
	
	struct SubTitle: View {
		let subTitle: String
		var purpleColor: Bool = false
		var customAlignment: Bool = false
		var customOpacity: Bool = false
		var body: some View {
			Text(subTitle)
				.font(.custom(FontManager.Primary.medium, size: 16))
				.foregroundColor(purpleColor ? .darkPurple : .white)
				.multilineTextAlignment(customAlignment ? .leading : .center)
				.opacity(customOpacity ? 0.7 : 0.6)
				.lineSpacing(5)
				.fixedSize(horizontal: false, vertical: true)
		}
	}
}

struct ScooterReusable_Previews: PreviewProvider {
    static var previews: some View {
		EmptyView()
    }
}
