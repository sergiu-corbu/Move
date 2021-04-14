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
        NavigationView {
            ScrollView {
                messageArea
                inputField
                resetButton
            }
            .padding([.leading, .trailing], 24)
            .background(Color.lightPurple)
            .edgesIgnoringSafeArea(.all)
        }
    }
    
    var messageArea: some View {
        VStack {
            HStack {
                Text("Reset password")
                    .foregroundColor(.white)
                    .font(Font.custom(FontManager.BaiJamjuree.bold, size: 32))
                Spacer()
            }
            .padding(.bottom, 40)
        }
        .padding(.top, 50)
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
        })
    }
}

struct ResetPassword_Previews: PreviewProvider {
    static var previews: some View {
        ResetPassword()
    }
}
