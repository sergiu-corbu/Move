//
//  Reusable Buttons.swift
//  Move
//
//  Created by Sergiu Corbu on 4/11/21.
//

import SwiftUI
import Introspect

//MARK: Register & login elements
struct AuthComponents {
	
    static var appLogo: some View {
        Image("logoOverlay-img")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 100, height: 100)
            .padding(.leading, -10)
    }
   
    struct BigTitle: View {
        let text: String
		
        var body: some View {
            Text(text)
                .foregroundColor(.white)
                .font(Font.custom(FontManager.Primary.bold, size: 32))
                .padding(.bottom, 15)
        }
    }
	
    struct MessageArea: View {
        let text: String
		
        var body: some View {
            VStack(alignment: .leading) {
                Text("Let's get started")
                    .font(Font.custom(FontManager.Primary.bold, size: 32))
                    .padding(.bottom, 15)
                Text(text)
                    .font(Font.custom(FontManager.Primary.medium, size: 20))
                    .opacity(0.6)
                    .lineSpacing(3)
                    .frame(height: 55)
                    .padding(.bottom, 5)
            }
            .foregroundColor(.white)
        }
    }
	
	struct SwitchAuthProcess: View {
		let questionText: String
		let solutionText: String
		let action: () -> Void

		var body: some View {
			HStack {
				Text(questionText)
					.font(Font.custom(FontManager.Primary.regular, size: 14))
				SharedElements.CustomSmallButton(text: solutionText, action: { action() })
			}
			.foregroundColor(.white)
			.padding(.bottom, 25)
		}
	}
}

// MARK: navigation bar
struct NavigationBar: View {
	
	var title: String?
	let color: Color
	var avatar: String?
	var flashLight: Bool?
	var backButton: String?
	var action: (() -> Void)?
	var action2: (() -> Void)?
	
	var body: some View {
		ZStack {
			Text(title ?? "")
				.font(.custom(FontManager.Primary.semiBold, size: 17))
				.foregroundColor(color)
				.frame(maxWidth: .infinity)
			if let avatar = avatar {
				HStack {
					Spacer()
					Image(avatar)
						.resizable()
						.aspectRatio(contentMode: .fill)
						.frame(width: 40, height: 40)
				}
			}
			if flashLight == true && action2 != nil {
				HStack {
					Spacer()
					Button(action: { action2!() }, label: {
						Image("bulb-img")
							.frame(width: 30, height: 30)
					})
				}
			}
			if let action = action, let backButton = backButton {
				HStack {
					Button(action: { action() }, label: {
						Image(backButton)
							.padding(.trailing, 15)
					})
					Spacer()
				}
			}
		}
		.padding(.top,10)
	}
}


enum FieldType: String {
	case email = "Email Address"
	case username = "Username"
	case password = "Password"
	case oldPassword = "Old password"
	case newPassword = "New Password"
	case confirmNewPassword = "Confirm new password"
}


struct CustomField: View {
	
	@Binding var input: String
	@State var activeField: Bool
	@State private var showSecured: Bool = true
	
	let textField: String
	var textColor: Color = Color.white
	var isSecuredField: Bool = false
	var error: String?
	var upperTextOpacity: Bool = false
	
	var body: some View {
		VStack(alignment: .leading, spacing: 0) {
			if input != "" || activeField {
				Text(textField)
					.foregroundColor(textColor)
					.font(Font.custom(FontManager.Primary.regular, size: 14))
					.opacity(upperTextOpacity ? 0.6 : 1)
			}
			HStack {
				HStack {
					if showSecured && isSecuredField {
						SecureField(activeField ? "" : textField, text: $input, onCommit: { activeField = false })
							.foregroundColor(textColor)
							.introspectTextField { textField in
								textField.returnKeyType = .done }
							.onTapGesture { activeField = true }
					} else {
						TextField(activeField ? "" : textField, text: $input, onCommit: { activeField = false })
							.foregroundColor(textColor)
							.introspectTextField { textField in
								textField.returnKeyType = .next }
							.onTapGesture { activeField = true }
					}
				}
				.font(Font.custom(FontManager.Primary.medium, size: 18))
				.accentColor(textColor)
				.autocapitalization(.none)
				.disableAutocorrection(true)
				.padding(.vertical, 7)
				Spacer()
				if !input.isEmpty && activeField {
					Button(action: {
							if isSecuredField { showSecured.toggle() } else { input = "" } }, label: {
								Image(isSecuredField ? ( showSecured ? "eye-img": "eye-off-img") : "close-img")
									.padding(.all, 5)
									.foregroundColor(.fadePurple) })
				}
			}
			if let error = self.error {
				if activeField && !input.isEmpty && !error.isEmpty {
					Divider()
						.padding(.bottom, 2)
						.background(Color.errorRed)
					Text(error)
						.foregroundColor(.errorRed)
						.font(.custom(FontManager.Primary.regular, size: 14))
				} else if !activeField && !input.isEmpty && !error.isEmpty  {
					Divider()
						.padding(.bottom, 1)
						.background(Color.errorRed)
					Text(error)
						.foregroundColor(.errorRed)
						.font(.custom(FontManager.Primary.regular, size: 14))
				}
				else {
					Divider()
						.padding(.bottom, activeField ? 2 : 1)
						.background(activeField ? Color.white : Color.fadePurple)
				} //maybe not
			} else {
				Divider()
					.padding(.bottom, activeField ? 2 : 1)
					.background(activeField ? Color.white : Color.fadePurple)
			}
		}.padding(.vertical, 6)
	}
}


struct SharedElements {
	
	static var singleScooter: some View {
		Image("pin-fill-active-img")
			.frame(width: 50, height: 50)
			.clipShape(Capsule())
	}
	
	static var checkmarkImage: some View {
		Image("checkmark-img")
			.resizable()
			.aspectRatio(contentMode: .fill)
			.frame(width: 172, height: 172)
	}
	
	static var purpleBackground: some View {
		Image("rect-background-img")
			.resizable()
			.aspectRatio(contentMode: .fill)
			.edgesIgnoringSafeArea(.all)
	}
	
	struct MapBarItems: View {
		let menuAction: () -> Void
		let text: String
		let locationEnabled: Bool
		let centerLocation: () -> Void
		
		var body: some View {
			ZStack {
				Image("fademap-img")
					.resizable()
					.aspectRatio(contentMode: .fill)
					.edgesIgnoringSafeArea(.top)
					.opacity(0.8)
					.frame(height: 70)
				HStack {
					Buttons.MapActionButton(image: "menu-img", action: { menuAction() })
					Spacer()
					Text(text)
						.foregroundColor(.darkPurple)
						.font(.custom(FontManager.Primary.semiBold, size: 18))
					Spacer()
					Buttons.MapActionButton(image: locationEnabled ? "location-img" : "locationDenied", action: { locationEnabled ? centerLocation() : nil })
				}
				.padding(.horizontal, 24)
			}
		}
	}
	
	struct CustomSmallButton: View {
		let text: String
		let action: () -> Void
		
		var body: some View {
			Button(action: { action() }, label: {
				Text(text)
					.font(.custom(FontManager.Primary.semiBold, size: 14))
					.bold()
					.underline()
			})
		}
	}
	
	static var whiteRoundedRectangle: some View {
		return Color.white.cornerRadius(32, corners: [.topLeft, .topRight]).edgesIgnoringSafeArea(.bottom)
	}
	
	static var whiteBackground: some View {
		return Color.white.edgesIgnoringSafeArea(.all)
	}

	struct ClusterPin: View {
		let number: Int
		let onTapCluster: () -> Void
		
		var body: some View {
			Image("pin-fill-img")
				.frame(width: 50, height: 50)
				.clipShape(Capsule())
				.overlay(
					Text(number.description)
						.font(.caption)
						.padding(.bottom, 5)
				)
				.onTapGesture {
					onTapCluster()
				}
		}
	}
}

struct TripReusable {
	
	struct TripLocation: View {
		let infoText: String
		let address: String
		var extraPadding: Bool = true
		var spaceBetween: CGFloat = 0
		var expandInline: Bool = false
		
		var body: some View {
			VStack(alignment: .leading) {
				Text(infoText)
					.foregroundColor(.fadePurple)
					.font(.custom(FontManager.Primary.medium, size: 12))
					.padding(.bottom, spaceBetween)
				Text(address)
					.foregroundColor(.darkPurple)
					.font(.custom(FontManager.Primary.bold, size: 14))
					.frame(maxWidth: expandInline ? .infinity : 180, alignment: .leading)
					.lineLimit(3)
			}
			.padding(.vertical, 7)
			.padding(.leading, extraPadding ? 25 : 20)
		}
	}
	
	struct TripData: View {
		
		let infoText: String
		let data: String
		var showTime: Bool = false
		
		var body: some View {
			VStack(alignment: .leading) {
				Text(infoText)
					.foregroundColor(.fadePurple)
					.font(.custom(FontManager.Primary.medium, size: 12))
				Text(!showTime ? "\(data) km" : "\(data) min")
					.foregroundColor(.darkPurple)
					.font(.custom(FontManager.Primary.bold, size: 14))
					.frame(maxWidth: 80, alignment: .leading)
					.lineLimit(1)
			}
			.padding(.vertical, 7)
			.padding(.trailing, 10)
		}
	}
}
