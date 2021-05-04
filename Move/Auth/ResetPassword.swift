//
//  ResetPassword.swift
//  Move
//
//  Created by Sergiu Corbu on 13.04.2021.
//

import SwiftUI

struct ResetPassword: View {
    
    @StateObject var userViewModel: UserViewModel = UserViewModel()
    @State private var newPasswordField: Bool = false
    @State private var confirmPasswordField: Bool = false
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
				else { print( "errorh") } //swift messages
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
            InputField(activeField: $newPasswordField, input: $userViewModel.password, textField: "New password", isSecuredField: true, textColor: .white, error: userViewModel.passwordError, action: {
                newPasswordField = true
                confirmPasswordField = false
            })
            InputField(activeField: $confirmPasswordField, input: $userViewModel.repeatPassword, textField: "New password", isSecuredField: true, textColor: .white, error: userViewModel.repeatPasswordError, action: {
                newPasswordField = false
                confirmPasswordField = true
            })
        }
    }
}

struct ResetPassword_Previews: PreviewProvider {
    static var previews: some View {
        ResetPassword(onBack: {})
    }
}
