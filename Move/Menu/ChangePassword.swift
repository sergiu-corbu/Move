//
//  ChangePassword.swift
//  Move
//
//  Created by Sergiu Corbu on 17.04.2021.
//

import SwiftUI

struct ChangePassword: View {
	
	@ObservedObject private var userViewModel = UserViewModel.shared
	@State private var confirmPassword: String = ""
	
    let passwordNavigation: (MenuNavigation) -> Void
    
    var body: some View {
        VStack(alignment: .leading) {
            NavigationBar(title: "Change password", color: .darkPurple, backButton: "chevron-left-purple", action: {
				passwordNavigation(.goBack)
			})
            inputArea
            Spacer()
			Buttons.PrimaryButton(text: "Save edits", isLoading: userViewModel.isLoading, enabled: userViewModel.validatePasswords, action: {
				userViewModel.isLoading = true
				userViewModel.resetPasswordCall {
					userViewModel.isLoading = false
					passwordNavigation(.goBack)
				}
            })
			.padding(.bottom)
        }
		.padding(.horizontal, 24)
		.background(Color.white.edgesIgnoringSafeArea(.all))
    }
    
    var inputArea: some View {
        VStack(alignment: .leading, spacing: 20) {
			CustomField(input: $userViewModel.password, activeField: userViewModel.isActive, textField: FieldType.oldPassword.rawValue, textColor: Color.darkPurple,isSecuredField: true, upperTextOpacity: true)
			CustomField(input: $userViewModel.newPassword, activeField: userViewModel.isActive, textField: FieldType.newPassword.rawValue, textColor: Color.darkPurple, isSecuredField: true,  upperTextOpacity: true)
			CustomField(input: $confirmPassword, activeField: userViewModel.isActive, textField: FieldType.confirmNewPassword.rawValue, textColor: Color.darkPurple, isSecuredField: true, upperTextOpacity: true)
        }.padding(.top, 40)
    }
}

struct ChangePasswordView_Previews: PreviewProvider {
    static var previews: some View {
		ChangePassword(passwordNavigation: { _ in })
            .preferredColorScheme(.light)
    }
}
