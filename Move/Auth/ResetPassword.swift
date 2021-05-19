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
	let onFinish: () -> Void
    
    var body: some View {
        VStack(alignment: .leading) {
			NavigationBar(color: .white, backButton: "chevron-left-white", action: { onBack() })
                .padding(.leading, -5)
			AuthComponents.BigTitle(text: "Reset password")
            inputField
			Buttons.PrimaryButton(text: "Reset Password", enabled: userViewModel.validatePasswords, action: {
				buttonAction()
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
			CustomField(input: $userViewModel.password, activeField: userViewModel.isActive, textField: FieldType.oldPassword.rawValue, isSecuredField: true, error: userViewModel.passwordError)
			CustomField(input: $userViewModel.newPassword, activeField: userViewModel.isActive, textField: FieldType.newPassword.rawValue, isSecuredField: true, error: userViewModel.newPasswordError)
        }
    }
	
	private func buttonAction() {
		if userViewModel.validatePasswords {
			userViewModel.resetPasswordCall {
				onFinish()
			}
		}
		else {
			userViewModel.password = ""
			userViewModel.newPassword = ""
			showError(error: "Couldn't reset")
		}
	}
}

struct ResetPassword_Previews: PreviewProvider {
    static var previews: some View {
		ResetPassword(onBack: {}, onFinish: {})
    }
}
