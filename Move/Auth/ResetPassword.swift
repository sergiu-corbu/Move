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
    @State private var validatePassword: Bool? = false
    //@State private var showAlert: Bool = false
    private var isEnabled: Bool {
        return userViewModel.password != "" && userViewModel.repeatPassword != ""
    }
    
    let onBack: () -> Void
    
    var body: some View {
        VStack(alignment: .leading) {
            NavigationBar(title: nil, color: nil, avatar: nil, flashLight: false, backButton: "chevron-left-white", action: { onBack() })
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
            InputPasswordReset(activeField: $newPasswordField, inputField: $userViewModel.password, text: "New password", action: {
                newPasswordField = true
                confirmPasswordField = false
            })
            InputPasswordReset(activeField: $confirmPasswordField, inputField: $userViewModel.repeatPassword, text: "Confirm new password", action: {
                newPasswordField = false
                confirmPasswordField = true
            })
        }
    }
    var resetButton: some View {
        CallToActionButton(enabled: isEnabled, text: "Reset Password", action: {
            if userViewModel.repeatPassword == userViewModel.password {
                validatePassword = true
                userViewModel.password = ""
                newPasswordField = false
                userViewModel.repeatPassword = ""
                confirmPasswordField = false
            }
            else { print( "password doesn't match") }
        }).padding(.top, 20)
    }
}

struct ResetPassword_Previews: PreviewProvider {
    static var previews: some View {
        ResetPassword(onBack: {})
    }
}
