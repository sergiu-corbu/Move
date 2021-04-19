//
//  Login.swift
//  Move
//
//  Created by Sergiu Corbu on 13.04.2021.
//

import SwiftUI
import Alamofire
import NavigationStack

struct Login: View {
    @StateObject private var userViewModel = UserViewModel()
    @State private var emailTyping: Bool = false
    @State private var passwordTyping: Bool = false
    @State private var isLoading: Bool = false
    
    let onLoginCompleted: () -> Void
    let onRegisterSwitch: () -> Void
    
    var allfieldsCompleted: Bool {
        return userViewModel.email != "" && userViewModel.password != "" && isLoading == false
    }
    var allfieldsValidated: Bool {
        return userViewModel.emailError.isEmpty && userViewModel.passwordError.isEmpty
    }
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack (alignment: .leading) {
                logoArea
                messageArea
                inputArea
                getStartedButton
                goToRegister
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
            InputField(activeField: $emailTyping, input: $userViewModel.email, textField: "Email Address", image: "close-img", isSecuredField: false, textColor: .white,error: userViewModel.emailError, action: {
                emailTyping = true
                passwordTyping = false
            })
            InputField(activeField: $passwordTyping, input: $userViewModel.password, textField: "Password", image: "eye-img", isSecuredField: true, textColor: .white, error: userViewModel.passwordError , action: {
                emailTyping = false
                passwordTyping = true
            })
        }
    }
    
    var getStartedButton: some View {
        
        CallToActionButton(isLoading: isLoading, enabled: allfieldsCompleted, text: "Login", action: {
            isLoading = true
            API.login(email: userViewModel.email, password: userViewModel.password) { (result) in
                switch result {
                    case .success:
                        onLoginCompleted()
                        isLoading = false
                    case .failure(let error):
                        print(error.localizedDescription)
                        isLoading = false
                }
            }
        }).padding(.top, 20)
    }

    var goToRegister: some View {
        HStack {
            Text("Don't have an account? You can")
                .font(Font.custom(FontManager.Primary.regular, size: 14))
                .foregroundColor(.white)
            Button(action: {
               onRegisterSwitch()
            }, label: {
                Text("start with one here")
                    .foregroundColor(.white)
                    .font(.custom(FontManager.Primary.semiBold, size: 14))
                    .bold()
                    .underline()
            })
        }.padding(.bottom, 25)
    }
}

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        Login(onLoginCompleted: {}, onRegisterSwitch: {})
    }
}
