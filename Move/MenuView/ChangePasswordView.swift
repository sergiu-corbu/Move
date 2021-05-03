//
//  ChangePasswordView.swift
//  Move
//
//  Created by Sergiu Corbu on 17.04.2021.
//

import SwiftUI

struct ChangePasswordView: View {
    
    @State private var oldPassword: String = ""
    @State private var newPassword: String = ""
    @State private var confirmPassword: String = ""
    @State private var isLoading: Bool = false
    
    @State private var oldPasswordActive: Bool = false
    @State private var newPasswordActive: Bool = false
    @State private var confirmPasswordActive: Bool = false
    
    let onBack: () -> Void
    let onSave: () -> Void
    
    var allFiledsCompleted: Bool {
        return oldPassword != "" && newPassword != "" && confirmPassword != ""
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            NavigationBar(title: "Change password", color: .darkPurple, backButton: "chevron-left-purple", action: {
                onBack()
            })
            inputArea
            Spacer()
            ActionButton(isLoading: isLoading, enabled: allFiledsCompleted, text: "Save edits", action: {
                isLoading = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                    isLoading = false
                })
                onSave()
            }).padding(.bottom)
        }
		.padding(.horizontal, 24)
        .background(Color.white)
    }
    
    var inputArea: some View {
        VStack(alignment: .leading, spacing: 20) {
            InputField(activeField: $oldPasswordActive, input: $oldPassword, textField: "Old password", isSecuredField: false, textColor: Color.darkPurple, action: {
                oldPasswordActive = true
                newPasswordActive = false
                confirmPasswordActive = false
            })
            InputField(activeField: $newPasswordActive, input: $newPassword, textField: "New password", isSecuredField: false, textColor: Color.darkPurple, action: {
                oldPasswordActive = false
                newPasswordActive = true
                confirmPasswordActive = false
            })
            InputField(activeField: $confirmPasswordActive, input: $confirmPassword, textField: "Confirm new password", isSecuredField: true, textColor: Color.darkPurple, action: {
                oldPasswordActive = false
                newPasswordActive = false
                confirmPasswordActive = true
            })
        }.padding(.top, 40)
    }
}

struct ChangePasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ChangePasswordView(onBack: {}, onSave: {})
            .preferredColorScheme(.light)
    }
}
