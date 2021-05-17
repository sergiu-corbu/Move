//
//  ReusableButtons.swift
//  Move
//
//  Created by Sergiu Corbu on 28.04.2021.
//

import SwiftUI

//MARK: Buttons

struct Buttons {
	struct PrimaryButton: View {
		let text: String
		var isLoading: Bool = false
		var enabled: Bool = false
		var isBlackBackground: Bool = false
		let action: () -> Void
		
		var body: some View {
			HStack {
				Button(action: { action() }, label: {
					ZStack(alignment: .trailing) {
						HStack {
							Text(text)
							if isBlackBackground {
								Image("Alogo").padding(.top, -2)
								Text("Pay")
									.padding(.leading, -3)
									.padding(.top, -1) //maybe not ok
							}
						}
						.foregroundColor(enabled ? .white : .fadePurple)
						.font(enabled ? Font.custom(FontManager.Primary.bold, size: isBlackBackground ? 18 : 16) : Font.custom(FontManager.Primary.medium, size: 16))
						.frame(maxWidth: .infinity)
						.padding(.horizontal, 46)
						.padding(.all, 20)
						.background(RoundedRectangle(cornerRadius: 16.0)
										.strokeBorder(Color.coralRed, lineWidth: !isBlackBackground ? 1 : 0)
										.background(RoundedRectangle(cornerRadius: 16.0).fill(enabled ? (!isBlackBackground ? Color.coralRed : .black) : Color.clear))
										.opacity(enabled ? 1 : 0.3)
						)
						if isLoading == true {
							ProgressView()
								.progressViewStyle(CircularProgressViewStyle(tint: .white))
								.scaleEffect(1.5)
								.frame(width: 30, height: 30)
								.padding(.trailing, 16)
						}
					}
				}).disabled(!enabled)
			}.padding(.vertical, 24)
		}
	}
	
	struct MapActionButton: View {
		let image: String
		let action: () -> Void
		var border: Bool = false
		
		var body: some View {
			Button(action: { action() }, label: {
				ZStack {
					if border {
						RoundedRectangle(cornerRadius: 13)
							.strokeBorder(Color.lightGray)
							.foregroundColor(.white)
					} else { RoundedRectangle(cornerRadius: 13).foregroundColor(.white) }
					Image(image)
				}
				.shadow(color: Color(UIColor.systemGray5), radius: 3, x: 5, y: 4)
				.frame(width: 36, height: 36)
			})
		}
	}
	
	struct UnlockButton: View {
		let text: String
		let action: () -> Void
		
		var body: some View {
			Button(action: { action() }, label: {
				RoundedRectangle(cornerRadius: 16)
					.stroke(Color.coralRed, lineWidth: 1.5)
					.frame(width: 95, height: 56)
					.background(Color.white)
					.overlay(
						Text(text)
							.foregroundColor(.coralRed)
							.font(.custom(FontManager.Primary.bold, size: 14)))
			})
		}
	}
	
	struct UnlockOptionButton: View {
		let text: String
		let action: () -> Void
		
		var body: some View {
			Button(action: { action() }, label: {
				RoundedRectangle(cornerRadius: 16)
					.strokeBorder(Color.white)
					.background(Color.white.opacity(0.2))
					.overlay(
						Text(text)
							.foregroundColor(.white)
							.font(.custom(FontManager.Primary.bold, size: 16)))
					.frame(width: 56, height: 56)
					.clipShape(RoundedRectangle(cornerRadius: 16))
			})
		}
	}

}
