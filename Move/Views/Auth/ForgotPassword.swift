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
        NavigationView {
            ScrollView {
                messageArea
                emailField
                sendResetButton
            }
            .padding([.leading, .trailing], 24)
            .background(Color.lightPurple)
            .edgesIgnoringSafeArea(.all)
            .alert(isPresented: $showAlert) {
                Alert.init(title: Text("Password reset link sent"), message: Text("Please check your inbox or spam for the email containing the password reset link"), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    var messageArea: some View {
        VStack {
            HStack {
                Text("Forgot password")
                    .foregroundColor(.white)
                    .font(Font.custom(FontManager.BaiJamjuree.bold, size: 32))
                Spacer()
            }
            .padding(.bottom, 15)
            
            HStack {
                Text("Enter the email address you’re\nusing for your account bellow and we’ll send you a password reset link.")
                    .foregroundColor(.white)
                    .font(Font.custom(FontManager.BaiJamjuree.medium, size: 17))
                    .opacity(0.6)
                    .lineSpacing(3)

                Spacer()
            }
            .padding(.bottom, 30)
        }
        .padding(.top, 50)
    }
    var emailField: some View {
        
        VStack(alignment: .leading, spacing: 0) {
            if activeField || !email.isEmpty {
                Text("Email Address")
                    .foregroundColor(.fadePurple)
                    .font(Font.custom(FontManager.BaiJamjuree.regular, size: 14))
            }
            HStack {
                TextField(activeField ? "" : "Email Address", text: $email)
                    .foregroundColor(.white)
                    .font(Font.custom(FontManager.BaiJamjuree.medium, size: 18))
                    .padding(.bottom, 10)
                    .padding(.top, 5)
                    .disableAutocorrection(true)
                    .onTapGesture { activeField = true }
                Spacer()
            }
            Divider()
                .padding(.bottom, activeField ? 2 : 1)
                .background(activeField ? Color.white : Color.fadePurple)
        }.padding(.bottom, 12)
    }
    var sendResetButton: some View {
        CallToActionButton(enabled: isEnabled, text: "Send Reset Link", action: {
            email = ""
            activeField = false
            showAlert.toggle()
        })
    }
}

struct ForgotPassword_Previews: PreviewProvider {
    static var previews: some View {
        ForgotPassword()
    }
}
