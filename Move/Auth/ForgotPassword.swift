//
//  ForgotPassword.swift
//  Move
//
//  Created by Sergiu Corbu on 13.04.2021.
//

import SwiftUI

struct ForgotPassword: View {
    @State private var showAlert: Bool = false
    @State private var activeField: Bool = false
    @StateObject var userViewModel: UserViewModel = UserViewModel()

    let onBack: () -> Void
    let onCompleted: () -> Void
    
    var body: some View {
        VStack(alignment: .leading) {
            NavigationBar(color: .white, backButton: "chevron-left-white", action: { onBack() }).padding(.leading, -5)
            messageArea
            InputField(activeField: $activeField, input: $userViewModel.email, textField: "Email Address", isSecuredField: false, textColor: .white, error: userViewModel.emailError , action: { activeField = true })
			ActionButton(enabled: userViewModel.resetPasswordEnabled && userViewModel.emailError.isEmpty, text: "Send Reset Link", action: {
                userViewModel.email = ""
                activeField = false
                onCompleted()
                showAlert.toggle()
            })
			.padding(.top, 20)
            Spacer()
        }
		.onTapGesture { hideKeyboard() }
        .padding(.horizontal, 24)
		.background(SharedElements.purpleBackground)
        .alert(isPresented: $showAlert) {
            Alert.init(title: Text("Password reset link sent"), message: Text("Please check your inbox or spam for the email containing the password reset link"), dismissButton: .default(Text("OK")))
        }
    }
	var messageArea: some View {
		VStack(alignment: .leading) {
			RegisterElements.BigTitle(text: "Forgot password")
			Text("Enter the email address you’re\nusing for your account bellow and we’ll send you a password reset link.")
				.foregroundColor(.white)
				.font(Font.custom(FontManager.Primary.medium, size: 17))
				.opacity(0.6)
				.lineSpacing(3)
		}
		.padding(.bottom, 30)
	}
}

struct ForgotPassword_Previews: PreviewProvider {
    static var previews: some View {
        ForgotPassword(onBack: {}, onCompleted: {})
    }
}
