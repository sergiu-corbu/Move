//
//  ResetPassword.swift
//  Move
//
//  Created by Sergiu Corbu on 13.04.2021.
//

import SwiftUI

struct ResetPassword: View {
    @State private var newPassword: String = ""
    @State private var newPasswordField: Bool = false
    @State private var confirmPassword: String = ""
    @State private var confirmPasswordField: Bool = false
    @State private var validatePassword: Bool? = false
    //@State private var showAlert: Bool = false
    private var isEnabled: Bool {
        return newPassword != ""
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            NavigationBar(title: nil, avatar: nil, backButton: "chevron-left-white", action: {})
                .padding(.leading, -5)
            messageArea
            inputField
            resetButton
            Spacer()
        }
        .padding([.leading, .trailing], 24)
        .background(
            Color.lightPurple
                .edgesIgnoringSafeArea(.all)
        )
    }
    
    var messageArea: some View {
        VStack(alignment: .leading) {
            Text("Reset password")
                .foregroundColor(.white)
                .font(Font.custom(FontManager.Primary.bold, size: 32))
                .padding(.bottom, 40)
        }
    }
    var inputField: some View {
        VStack {
            InputPasswordReset(activeField: $newPasswordField, inputField: $newPassword, text: "New password", action: {
                newPasswordField = true
                confirmPasswordField = false
            })
            InputPasswordReset(activeField: $confirmPasswordField, inputField: $confirmPassword, text: "Confirm new password", action: {
                newPasswordField = false
                confirmPasswordField = true
            })
        }
    }
    var resetButton: some View {
        CallToActionButton(enabled: isEnabled, text: "Reset Password", action: {
            if newPassword == confirmPassword {
                validatePassword = true
                newPassword = ""
                newPasswordField = false
                confirmPassword = ""
                confirmPasswordField = false
            }
            else { print("passwords don;t match") }
        }).padding(.top, 20)
    }
}

struct ResetPassword_Previews: PreviewProvider {
    static var previews: some View {
        ResetPassword()
    }
}
