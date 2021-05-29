//
//  Register.swift
//  Move
//
//  Created by Sergiu Corbu on 4/7/21.
//

import SwiftUI
import BetterSafariView
import Introspect

struct Register: View {
	
	@ObservedObject var userViewModel = UserViewModel.shared
    @State private var termsPresented: Bool = false
    @State private var privacyPresented: Bool = false
	
	let authNavigation: (AuthNavigation) -> Void

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading) {
				AuthComponents.appLogo
				AuthComponents.MessageArea(text: "Sign up or login and start\nriding right away")
                inputArea
                agreement
				Buttons.PrimaryButton(text: "Get started", isLoading: userViewModel.isLoading, enabled: userViewModel.allfieldsCompletedRegister, action: { buttonTapped() })
				AuthComponents.SwitchAuthProcess(questionText: "You already have an account? You can", solutionText: "log in here", action: { authNavigation(.switchToLogin)
				})
				.ignoresSafeArea(.keyboard, edges: .bottom)
            }
            Spacer()
        }
		.colorScheme(.dark)
		.onTapGesture { hideKeyboard() }
        .padding(.horizontal, 24)
		.background(SharedElements.purpleBackground)
    }
    
	var inputArea: some View {
		VStack(alignment: .leading) {
			CustomField(input: $userViewModel.email, activeField: userViewModel.isActive, textField: FieldType.email.rawValue, error: userViewModel.emailError)
			CustomField(input: $userViewModel.username, activeField: userViewModel.isActive, textField: FieldType.username.rawValue)
			VStack(alignment: .leading) {
				CustomField(input: $userViewModel.password, activeField: userViewModel.isActive, textField: FieldType.password.rawValue, isSecuredField: true, error: userViewModel.passwordError)
				if userViewModel.password == "" && userViewModel.isActive  {
					Text("Use a strong password (min. 8 characters and use symbols")
						.font(.custom(FontManager.Primary.regular, size: 13))
						.foregroundColor(.white)
				}
			}
		}
	}

    var agreement: some View {
        VStack(alignment: .leading) {
            Text("By continuing you agree to Move’s")
                .font(.custom(FontManager.Primary.medium, size: 14))
            HStack {
				SharedElements.CustomSmallButton(text: "Terms and Conditions", action: { termsPresented=true })
                .safariView(isPresented: $termsPresented) { safariView as! SafariView }
                Text("and")
                    .font(.custom(FontManager.Primary.medium, size: 14))
                    .padding(.horizontal, -3)
				SharedElements.CustomSmallButton(text: "Privacy Policy", action: { privacyPresented = true })
                .safariView(isPresented: $privacyPresented) { safariView as! SafariView }
                Spacer()
            }
        }
        .foregroundColor(.white)
        .padding(.top, 20)
    }
    var safariView: some View {
        SafariView(url: URL(string: "https://tapptitude.com")!, configuration: SafariView.Configuration(entersReaderIfAvailable: false, barCollapsingEnabled: true))
            .dismissButtonStyle(.close)
    }
	
	private func buttonTapped() {
		userViewModel.validateFields()
		if  userViewModel.allfieldsValidatedRegister {
			userViewModel.isLoading = true
			userViewModel.registerCall { authNavigation(.registerCompleted) }
		}
	}
}

struct Register_Previews: PreviewProvider {
    static var previews: some View {
		Register { _ in}
			
	}
}
