//
//  Login.swift
//  Move
//
//  Created by Sergiu Corbu on 13.04.2021.
//

import SwiftUI

struct Login: View {
	@ObservedObject private var userViewModel = UserViewModel()
    let onLoginCompleted: () -> Void
    let onRegisterSwitch: () -> Void
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack (alignment: .leading) {
				AuthComponents.appLogo
				AuthComponents.MessageArea(text: "Sign up or login and start\nriding right away")
				CustomField(input: $userViewModel.email, activeField: userViewModel.isActive, textField: FieldType.email.rawValue)
				CustomField(input: $userViewModel.password, activeField: userViewModel.isActive, textField: FieldType.password.rawValue, isSecuredField: true)
				Buttons.PrimaryButton(text: "Login", isLoading: userViewModel.isLoading, enabled: userViewModel.allfieldsCompletedLogin && userViewModel.allfieldsValidatedLogin, action: {
					userViewModel.isLoading = true
					userViewModel.loginCall {
						onLoginCompleted()
					}
				})
				AuthComponents.SwitchAuthProcess(questionText: "Don't have an account? You can", solutionText: "start with one here", action: { onRegisterSwitch() })
            }
            Spacer()
        }
		.onTapGesture { hideKeyboard() }
        .padding(.horizontal, 24)
		.background(SharedElements.purpleBackground)
    }
}

struct Login_Previews: PreviewProvider {
    static var previews: some View {
		Login(onLoginCompleted: {}, onRegisterSwitch: {})
			.preferredColorScheme(.dark)
    }
}
