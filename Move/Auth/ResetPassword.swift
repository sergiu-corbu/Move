//
//  ResetPassword.swift
//  Move
//
//  Created by Sergiu Corbu on 13.04.2021.
//

import SwiftUI

struct ResetPassword: View {
	@ObservedObject private var userViewModel = UserViewModel.shared
    @State private var showAlert: Bool = false
    
    let onBack: () -> Void
    
    var body: some View {
        VStack(alignment: .leading) {
			NavigationBar(color: .white, backButton: "chevron-left-white", action: { onBack() })
                .padding(.leading, -5)
			RegisterElements.BigTitle(text: "Reset password")
            inputField
			ActionButton(enabled: userViewModel.validatePasswords, text: "Reset Password", action: {
				if userViewModel.validatePasswords {
					userViewModel.password = ""
					userViewModel.repeatPassword = ""
				}
				else { showError(error: "Couldn't reset") }
			})
			.padding(.top, 20)
			.alert(isPresented: $showAlert) {
				Alert.init(title: Text("Password reset successful"), message: Text("Ok"), dismissButton: .default(Text("OK")))
			}
            Spacer()
        }
		.onTapGesture { hideKeyboard() }
        .padding(.horizontal, 24)
		.background(SharedElements.purpleBackground)
    }

    var inputField: some View {
        VStack {
			InputField(input: $userViewModel.password, activeField: userViewModel.isActive, textField: "New password", isSecuredField: true, textColor: .white, error: userViewModel.passwordError)
			InputField(input: $userViewModel.repeatPassword, activeField: userViewModel.isActive, textField: "New password", isSecuredField: true, textColor: .white, error: userViewModel.repeatPasswordError)
        }
    }
}

struct ResetPassword_Previews: PreviewProvider {
    static var previews: some View {
        ResetPassword(onBack: {})
    }
}
