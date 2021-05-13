//
//  Register.swift
//  Move
//
//  Created by Sergiu Corbu on 4/7/21.
//

import SwiftUI
import BetterSafariView

struct Register: View {
	@ObservedObject private var userViewModel = UserViewModel.shared
    @State private var termsPresented: Bool = false
    @State private var privacyPresented: Bool = false
    
    let onRegisterComplete: () -> Void
    let onLoginSwitch: () -> Void

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading) {
				RegisterElements.logoArea
				RegisterElements.MessageArea(text: "Sign up or login and start\nriding right away")
                inputArea
                agreement
                getStartedButton
				RegisterElements.SwitchAuthProcess(questionText: "You already have an account? You can", solutionText: "log in here", action: { onLoginSwitch() })
            }
            Spacer()
        }
		.onTapGesture { hideKeyboard() }
        .padding(.horizontal, 24)
		.background(SharedElements.purpleBackground)
    }
    
    var inputArea: some View {
        VStack(alignment: .leading) {
			CustomField(input: $userViewModel.email, activeField: userViewModel.isActive, textField: FieldType.email.rawValue, error: userViewModel.emailError)
			CustomField(input: $userViewModel.username, activeField: userViewModel.isActive, textField: FieldType.username.rawValue)
            VStack(alignment: .leading) {
				CustomField(input: $userViewModel.password, activeField: userViewModel.isActive, textField: FieldType.password.rawValue, isSecuredField: true, error: userViewModel.passwordError)
                if userViewModel.password == "" && userViewModel.isActive  {
                    Text("Use a strong password (min. 8 characters and use symbols")
                        .font(.custom(FontManager.Primary.regular, size: 13))
                        .foregroundColor(.white)
                }
            }
        }
    }
    
    var getStartedButton: some View {
		ActionButton(text: "Get started", isLoading: userViewModel.isLoading, enabled: userViewModel.allfieldsCompletedRegister && userViewModel.allfieldsValidatedRegister, action: {
            userViewModel.isLoading = true
			userViewModel.registerCall { onRegisterComplete() }
        }).padding(.top, 20)
    }
    
    var agreement: some View {
        VStack(alignment: .leading) {
            Text("By continuing you agree to Move’s")
                .font(.custom(FontManager.Primary.medium, size: 14))
            HStack {
                Button(action: { termsPresented = true }, label: {
                    Text("Terms and Conditions")
                        .font(.custom(FontManager.Primary.semiBold, size: 14))
                        .bold()
                        .underline()
                })
                .safariView(isPresented: $termsPresented) { safariView as! SafariView }
                Text("and")
                    .font(.custom(FontManager.Primary.medium, size: 14))
                    .padding(.horizontal, -3)
                Button(action: { privacyPresented = true }, label: {
                    Text("Privacy Policy")
                        .font(.custom(FontManager.Primary.semiBold, size: 14))
                        .bold()
                        .underline()
                })
                .safariView(isPresented: $privacyPresented) { safariView as! SafariView }
                Spacer()
            }
        }
        .foregroundColor(.white)
        .padding(.top, 20)
    }
    var safariView: some View {
        SafariView(url: URL(string: "https://tapptitude.com")!, configuration: SafariView.Configuration(entersReaderIfAvailable: false, barCollapsingEnabled: true))
            .dismissButtonStyle(.close)
    }
}

struct Register_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(["iPhone 12", "iPhone SE (2nd generation)"], id: \.self) { deviceName in
            Register(onRegisterComplete: {}, onLoginSwitch: {})
                .previewDevice(PreviewDevice(rawValue: deviceName))
                .previewDisplayName(deviceName)
        }
        .preferredColorScheme(.dark)
    }
}

/*
struct ErrowAlert: UIViewRepresentable {
    
    func makeUIView(context: Context) -> some UIView {
        
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}
*/
