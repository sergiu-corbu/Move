//
//  Login.swift
//  Move
//
//  Created by Sergiu Corbu on 13.04.2021.
//

import SwiftUI

struct Login: View {
    @StateObject private var userViewModel = UserViewModel()
    @State private var emailTyping: Bool = false
    @State private var passwordTyping: Bool = false
    
    let onLoginCompleted: () -> Void
    let onRegisterSwitch: () -> Void
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack (alignment: .leading) {
				RegisterElements.logoArea
				RegisterElements.MessageArea(text: "Sign up or login and start\nriding right away")
                inputArea
				ActionButton(isLoading: userViewModel.isLoading, enabled: userViewModel.allfieldsCompletedLogin && userViewModel.allfieldsValidatedLogin, text: "Login", action: {
					userViewModel.isLoading = true
					API.login(email: userViewModel.email, password: userViewModel.password) { (result) in
						switch result {
							case .success(let result):
								Session.tokenKey = result.token
								onLoginCompleted()
								userViewModel.isLoading = false
							case .failure(let error):
								showError(error: error.localizedDescription)
								userViewModel.isLoading = false
						}
					}
				}).padding(.top, 20)
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
            InputField(activeField: $emailTyping, input: $userViewModel.email, textField: "Email Address", isSecuredField: false, textColor: .white, action: {
                emailTyping = true
                passwordTyping = false
            })
            InputField(activeField: $passwordTyping, input: $userViewModel.password, textField: "Password", isSecuredField: true, textColor: .white, action: {
                emailTyping = false
                passwordTyping = true
            })
        }
    }
}

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        Login(onLoginCompleted: {}, onRegisterSwitch: {})
    }
}
