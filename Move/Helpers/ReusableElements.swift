//
//  Reusable Buttons.swift
//  Move
//
//  Created by Sergiu Corbu on 4/11/21.
//

import SwiftUI
import Introspect

//MARK: Register & login elements
struct RegisterElements {
    static var logoArea: some View {
        Image("logoOverlay-img")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 100, height: 100)
            .padding(.leading, -10)
    }
    static var purpleBackground: some View {
        Image("rect-background-img")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .edgesIgnoringSafeArea(.all)
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
				Button(action: {
					action()
				}, label: {
					Text(solutionText)
						.font(.custom(FontManager.Primary.semiBold, size: 14))
						.bold()
						.underline()
				})
			}
			.foregroundColor(.white)
			.padding(.bottom, 25)
		}
	}
}

// MARK: navigation bar
struct NavigationBar: View {
	let title: String
	let color: Color?
	let avatar: String?
	let flashLight: Bool
	let backButton: String
	let action: () -> Void
	
	var body: some View {
		ZStack {
			HStack {
				Text(title)
					.font(.custom(FontManager.Primary.semiBold, size: 17))
					.foregroundColor(color)
					.frame(maxWidth: .infinity)
			}
			if let avatar = avatar {
				HStack {
					Spacer()
					Image(avatar)
						.resizable()
						.aspectRatio(contentMode: .fill)
						.frame(width: 40, height: 40)
				}
			}
			if flashLight == true {
				HStack {
					Spacer()
					Image("bulb-img")
						.padding(.trailing, 15)
				}
			}
			HStack {
				Button(action: { action() }, label: {
					Image(backButton)
						.padding(.trailing, 15)
				})
				Spacer()
			}
		}
	}
}

//MARK: fields
struct InputField: View {
	
	@Binding var activeField: Bool
	@Binding var input: String
	@State private var showSecured: Bool = true
	
	let textField: String
	let isSecuredField: Bool
	let textColor: Color
	var error: String?
	let action: () -> Void
	
	var body: some View {
		VStack(alignment: .leading, spacing: 0) {
			if !input.isEmpty || activeField {
				Text(textField)
					.foregroundColor(.white)
					.font(Font.custom(FontManager.Primary.regular, size: 14))
			}
			HStack {
				HStack {
					if showSecured && isSecuredField {
						SecureField(activeField ? "" : textField, text: $input)
							.introspectTextField { textField in
								textField.returnKeyType = .done }
					} else {
						TextField(activeField ? "" : textField, text: $input)
							.introspectTextField { textField in
								textField.returnKeyType = .next }
					}
				}
				.foregroundColor(textColor)
				.font(Font.custom(FontManager.Primary.medium, size: 18))
				.accentColor(textColor)
				.autocapitalization(.none)
				.disableAutocorrection(true)
				.padding(.vertical, 7)
				.onTapGesture {
					activeField = true
					action()
				}
				Spacer()
				if !input.isEmpty && activeField {
					Button(action: {
						if isSecuredField { showSecured.toggle() } else { input = "" } }, label: {
							Image( isSecuredField ? ( showSecured ? "eye-img": "eye-off-img") : "close-img")
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

struct Shapes {
	static var checkmarkImage: some View {
		Image("checkmark-img")
			.resizable()
			.aspectRatio(contentMode: .fill)
			.frame(width: 172, height: 172)
			.padding(.top, 100)
	}
	
	struct NFCCircle: View {
		let width: CGFloat
		let height: CGFloat
		let opacity: Double
		var body: some View {
			Circle()
				.strokeBorder(Color.white, lineWidth: CGFloat(opacity*3))
				.opacity(opacity)
				.clipShape(Circle())
				.frame(width: width, height: height)
		}
	}
}

struct Reusable_Previews: PreviewProvider {
	static var previews: some View {
		InputField(activeField: .constant(true), input: .constant("sergiucorbu@icloud.com"), textField: "Enter email", isSecuredField: false, textColor: .white, error: "error", action: {})
	}
}
