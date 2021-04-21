//
//  Register.swift
//  Move
//
//  Created by Sergiu Corbu on 4/7/21.
//

import SwiftUI
import BetterSafariView
import NavigationStack
import Alamofire

struct Register: View {

    @State private var emailTyping: Bool = false
    @State private var passwordTyping: Bool = false
    @State private var usernameTyping: Bool = false
    @StateObject private var userViewModel = UserViewModel()
    
    @State private var termsPresented: Bool = false
    @State private var privacyPresented: Bool = false
    @State private var isLoading: Bool = false
    
    let onRegisterComplete: () -> Void
    let onLoginSwitch: () -> Void
    
    var allfieldsCompleted: Bool {
        return userViewModel.email != "" && userViewModel.username != "" && userViewModel.password != "" && isLoading == false
    }
    var allfieldsValidated: Bool {
        return userViewModel.emailError.isEmpty && userViewModel.passwordError.isEmpty
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading) {
                logoArea
                messageArea
                inputArea
                agreement
                getStartedButton
                goToLogin
            }
            Spacer()
        }
        .padding([.leading, .trailing], 24)
        .background(
            Image("rect-background-img")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
        )
    }
    
    var logoArea: some View {
        Image("logoOverlay-img")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 100, height: 100)
            .padding(.leading, -10)
    }
    
    var messageArea: some View {
        VStack(alignment: .leading) {
            Text("Let's get started")
                .foregroundColor(.white)
                .font(Font.custom(FontManager.Primary.bold, size: 32))
                .padding(.bottom, 15)
            Text("Sign up or login and start\nriding right away")
                .foregroundColor(.white)
                .font(Font.custom(FontManager.Primary.medium, size: 20))
                .opacity(0.6)
                .lineSpacing(3)
                .frame(height: 55)
                .padding(.bottom, 5)
        }
    }
    
    var inputArea: some View {
        VStack(alignment: .leading) {
            InputField(activeField: $emailTyping, input: $userViewModel.email, textField: "Email Address", image: "close-img", isSecuredField: false, textColor: .white, error: userViewModel.emailError, action: {
                    emailTyping = true
                    usernameTyping = false
                    passwordTyping = false
                })
            InputField(activeField: $usernameTyping, input: $userViewModel.username, textField: "Username", image: "close-img", isSecuredField: false, textColor: .white, action: {
                emailTyping = false
                usernameTyping = true
                passwordTyping = false
            })
            VStack(alignment: .leading) {
                InputField(activeField: $passwordTyping, input: $userViewModel.password, textField: "Password", image: "eye-img", isSecuredField: true, textColor: .white, error: userViewModel.passwordError,action: {
                    emailTyping = false
                    usernameTyping = false
                    passwordTyping = true
                })
                if userViewModel.password == "" && passwordTyping  {
                    Text("Use a strong password (min. 8 characters and use symbols")
                        .font(.custom(FontManager.Primary.regular, size: 13))
                        .foregroundColor(.white)
                }
            }
        }
    }
    
    var getStartedButton: some View {
        CallToActionButton(isLoading: isLoading, enabled: allfieldsCompleted && allfieldsValidated, text: "Get started", action: {
            isLoading = true
            API.register(username: userViewModel.username, email: userViewModel.email, password: userViewModel.password) { (result) in
                switch result {
                    case .success(let result):
                        Session.tokenKey = result.token
                        onRegisterComplete()
                        isLoading = false
                    case .failure(let error):
                        print(error.localizedDescription)
                        isLoading = false
                }
            }
        }).padding(.top, 20)
    }
    
    var agreement: some View {
        VStack(alignment: .leading) {
            Text("By continuing you agree to Move’s")
                .foregroundColor(.white)
                .font(.custom(FontManager.Primary.medium, size: 14))
            HStack {
                Button(action: {
                    termsPresented = true
                }, label: {
                    Text("Terms and Conditions")
                        .foregroundColor(.white)
                        .font(.custom(FontManager.Primary.semiBold, size: 14))
                        .bold()
                        .underline()
                })
                .safariView(isPresented: $termsPresented) {
                    SafariView(url: URL(string: "https://tapptitude.com")!, configuration: SafariView.Configuration(entersReaderIfAvailable: false, barCollapsingEnabled: true))
                        .dismissButtonStyle(.close)
                }
                Text("and")
                    .foregroundColor(.white)
                    .font(.custom(FontManager.Primary.medium, size: 14))
                    .padding([.trailing, .leading], -3)
                Button(action: {
                    privacyPresented = true
                }, label: {
                    Text("Privacy Policy")
                        .foregroundColor(.white)
                        .font(.custom(FontManager.Primary.semiBold, size: 14))
                        .bold()
                        .underline()
                })
                .safariView(isPresented: $privacyPresented) {
                    SafariView(url: URL(string: "https://tapptitude.com")!, configuration: SafariView.Configuration(entersReaderIfAvailable: false, barCollapsingEnabled: true))
                        .dismissButtonStyle(.close)
                }
                Spacer()
            }
        }
        .padding(.top, 20)
    }
    
    var goToLogin: some View {
        HStack {
            Text("You already have an account? You can")
                .font(Font.custom(FontManager.Primary.regular, size: 14))
                .foregroundColor(.white)
            Button(action: {
                onLoginSwitch()
               
            }, label: {
                Text("log in here")
                    .foregroundColor(.white)
                    .font(.custom(FontManager.Primary.semiBold, size: 14))
                    .bold()
                    .underline()
                    .padding(.leading, -3)
            })
        }
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
