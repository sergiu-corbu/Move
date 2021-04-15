//
//  ForgotPassword.swift
//  Move
//
//  Created by Sergiu Corbu on 13.04.2021.
//

import SwiftUI

struct ForgotPassword: View {
    
    @State private var email: String = ""
    @State private var showAlert: Bool = false
    @State private var activeField: Bool = false
    private var isEnabled: Bool {
        return email != ""
    }
    var body: some View {
        VStack(alignment: .leading) {
            NavigationBar(title: nil, backButton: "chevron-left-white", action: {})
                .padding(.leading, -29)
            messageArea
            emailField
            sendResetButton
            Spacer()
        }
        .padding([.leading, .trailing], 24)
        .background(
            Color.lightPurple
                .edgesIgnoringSafeArea(.all)
        )
        .alert(isPresented: $showAlert) {
            Alert.init(title: Text("Password reset link sent"), message: Text("Please check your inbox or spam for the email containing the password reset link"), dismissButton: .default(Text("OK")))
        }
    }
    var messageArea: some View {
        VStack(alignment: .leading) {
            Text("Forgot password")
                .foregroundColor(.white)
                .font(Font.custom(FontManager.Primary.bold, size: 32))
                .padding(.bottom, 15)
            Text("Enter the email address you’re\nusing for your account bellow and we’ll send you a password reset link.")
                .foregroundColor(.white)
                .font(Font.custom(FontManager.Primary.medium, size: 17))
                .opacity(0.6)
                .lineSpacing(3)
        }
        .padding(.bottom, 30)
    }
    var emailField: some View {
        InputField(activeField: $activeField, input: $email, textField: "Email Address", image: "", isSecuredField: false, action: {
            
        })
    }
    var sendResetButton: some View {
        CallToActionButton(enabled: isEnabled, text: "Send Reset Link", action: {
            email = ""
            activeField = false
            showAlert.toggle()
        }).padding(.top, 20)
    }
}

struct ForgotPassword_Previews: PreviewProvider {
    static var previews: some View {
        ForgotPassword()
    }
}
