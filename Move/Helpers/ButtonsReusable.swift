//
//  ButtonsReusable.swift
//  Move
//
//  Created by Sergiu Corbu on 28.04.2021.
//

import SwiftUI

//MARK: Buttons
struct ActionButton: View {
	var isLoading: Bool = false
	var enabled: Bool = false
	let text: String
	let action: () -> Void
	
	var body: some View {
		HStack {
			Button(action: {
				action()
			}, label: {
				ZStack(alignment: .trailing) {
					HStack {
						Text(text)
							.foregroundColor(enabled ? .white : .fadePurple)
							.font(enabled ? Font.custom(FontManager.Primary.bold, size: 16) : Font.custom(FontManager.Primary.medium, size: 16))
							.frame(maxWidth: .infinity)
							.padding(.horizontal, 46)
					}
					.padding(.all, 20)
					.background(RoundedRectangle(cornerRadius: 16.0)
									.strokeBorder(Color.coralRed, lineWidth: 1)
									.background(RoundedRectangle(cornerRadius: 16.0).fill(enabled ? Color.coralRed : Color.clear))
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
			})
			.disabled(!enabled)
		}
		.padding(.bottom, 20)
	}
}

struct MapActionButton: View {
	let image: String
	let action: () -> Void
	
	var body: some View {
		Button(action: { action() }, label: {
			ZStack {
				RoundedRectangle(cornerRadius: 13)
					.foregroundColor(.white)
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


struct ReusableButtons_Previews: PreviewProvider {
    static var previews: some View {
       // ReusableButtons()
		EmptyView()
    }
}
