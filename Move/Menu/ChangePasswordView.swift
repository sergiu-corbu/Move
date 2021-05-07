//
//  ChangePasswordView.swift
//  Move
//
//  Created by Sergiu Corbu on 17.04.2021.
//

import SwiftUI

struct ChangePasswordView: View {
	@ObservedObject private var userViewModel = UserViewModel.shared
	
    let onBack: () -> Void
    let onSave: () -> Void
    
    var body: some View {
        VStack(alignment: .leading) {
            NavigationBar(title: "Change password", color: .darkPurple, backButton: "chevron-left-purple", action: {
                onBack()
            })
            inputArea
            Spacer()
			ActionButton(isLoading: userViewModel.isLoading, enabled: userViewModel.validatePasswords, text: "Save edits", action: {
				userViewModel.isLoading = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
					userViewModel.isLoading = false
                })
                onSave()
            }).padding(.bottom)
        }
		.padding(.horizontal, 24)
        .background(Color.white)
    }
    
    var inputArea: some View {
        VStack(alignment: .leading, spacing: 20) {
			InputField(input: $userViewModel.password, activeField: userViewModel.isActive, textField: "Old password", isSecuredField: false, textColor: Color.darkPurple)
			InputField(input: $userViewModel.password, activeField: userViewModel.isActive, textField: "New password", isSecuredField: false, textColor: Color.darkPurple)
			InputField(input: $userViewModel.repeatPassword, activeField: userViewModel.isActive, textField: "Confirm new password", isSecuredField: true, textColor: Color.darkPurple)
        }.padding(.top, 40)
    }
}

struct ChangePasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ChangePasswordView(onBack: {}, onSave: {})
            .preferredColorScheme(.light)
    }
}
