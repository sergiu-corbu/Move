//
//  Login.swift
//  Move
//
//  Created by Sergiu Corbu on 13.04.2021.
//

import SwiftUI

struct Login: View {
	@ObservedObject private var userViewModel = UserViewModel.shared

    let onLoginCompleted: () -> Void
    let onRegisterSwitch: () -> Void
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack (alignment: .leading) {
				RegisterElements.logoArea
				RegisterElements.MessageArea(text: "Sign up or login and start\nriding right away")
                inputArea
				ActionButton(text: "Login", isLoading: userViewModel.isLoading, enabled: userViewModel.allfieldsCompletedLogin && userViewModel.allfieldsValidatedLogin, action: {
					userViewModel.isLoading = true
					userViewModel.loginCall{ onLoginCompleted() }
					})
				.padding(.top, 20)
				RegisterElements.SwitchAuthProcess(questionText: "Don't have an account? You can", solutionText: "start with one here", action: { onRegisterSwitch() })
            }
            Spacer()
        }
		.onTapGesture { hideKeyboard() }
        .padding(.horizontal, 24)
		.background(SharedElements.purpleBackground)
    }
    
    var inputArea: some View {
        VStack(alignment: .leading) {
			CustomField(input: $userViewModel.email, activeField: userViewModel.isActive, textField: FieldType.email.rawValue)
			CustomField(input: $userViewModel.password, activeField: userViewModel.isActive, textField: FieldType.password.rawValue, isSecuredField: true)
        }
    }
}

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        Login(onLoginCompleted: {}, onRegisterSwitch: {})
    }
}
