//
//  ChangePasswordView.swift
//  Move
//
//  Created by Sergiu Corbu on 17.04.2021.
//

import SwiftUI

struct ChangePasswordView: View {
	@ObservedObject private var userViewModel = UserViewModel.shared
    let action: () -> Void
    
    var body: some View {
        VStack(alignment: .leading) {
            NavigationBar(title: "Change password", color: .darkPurple, backButton: "chevron-left-purple", action: { action() })
            inputArea
            Spacer()
			ActionButton(isLoading: userViewModel.isLoading, enabled: userViewModel.validatePasswords, text: "Save edits", action: {
				userViewModel.isLoading = true
				// api call
                DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
					userViewModel.isLoading = false
                })
                action()
            }).padding(.bottom)
        }
		.padding(.horizontal, 24)
        .background(Color.white)
    }
    
    var inputArea: some View {
        VStack(alignment: .leading, spacing: 20) {
			InputField(input: $userViewModel.password, activeField: userViewModel.isActive, textField: InputFieldType.oldPassword.rawValue, textColor: Color.darkPurple)
			InputField(input: $userViewModel.password, activeField: userViewModel.isActive, textField: InputFieldType.newPassword.rawValue, textColor: Color.darkPurple)
			InputField(input: $userViewModel.repeatPassword, activeField: userViewModel.isActive, textField: InputFieldType.confirmNewPassword.rawValue, textColor: Color.darkPurple, isSecuredField: true)
        }.padding(.top, 40)
    }
}

struct ChangePasswordView_Previews: PreviewProvider {
    static var previews: some View {
		ChangePasswordView(action: {})
            .preferredColorScheme(.light)
    }
}
