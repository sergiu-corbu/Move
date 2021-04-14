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
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var emailTyping: Bool = false
    @State private var passwordTyping: Bool = false
    @State private var isLoading: Bool = false
    
    let onLoginCompleted: () -> Void
    var allfieldsCompleted: Bool {
        return email != ""  && password != ""
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            logoArea
            messageArea
            if isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .black))
                    .scaleEffect(3)
            }
            inputArea
            getStartedButton
            goToRegister
            Spacer()
        }
        .padding([.leading, .trailing], 24)
        .background(
            Image("rect-background-img")
                .resizable()
                .aspectRatio(contentMode: .fill)
        )
        .edgesIgnoringSafeArea(.all)
    }
    
    var logoArea: some View {
        HStack {
            Image("logoOverlay-img")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 100, height: 100)
            Spacer()
        }
        .padding(.leading, -10)
        .padding(.top, 30)
    }
    
    var messageArea: some View {
        VStack {
            HStack {
                Text("Login")
                    .foregroundColor(.white)
                    .font(Font.custom(FontManager.BaiJamjuree.bold, size: 32))
                Spacer()
            }
            .padding(.bottom, 15)
            
            HStack {
                Text("Enter your account credentials\nand start riding away.")
                    .foregroundColor(.white)
                    .font(Font.custom(FontManager.BaiJamjuree.medium, size: 20))
                    .opacity(0.6)
                    .lineSpacing(3)
                    .frame(height: 55) //maybe not
                Spacer()
            }
            .padding(.bottom, 5)
        }
    }
    
    var inputArea: some View {
        VStack(alignment: .leading) {
            InputField(activeField: $emailTyping, input: $email, textField: "Email Address", image: "close-img", isSecuredField: false, action: {
                emailTyping = true
                passwordTyping = false
            })

            InputField(activeField: $passwordTyping, input: $password, textField: "Password", image: "eye-img", isSecuredField: true, action: {
                emailTyping = false
                passwordTyping = true
            })
        }
    }
    
    var getStartedButton: some View {
        
        CallToActionButton(isLoading: isLoading, enabled: allfieldsCompleted, text: "Login", action: {
            isLoading = true
            API.login(email: email, password: password) { (result) in
                switch result {
                    case .success:
                        onLoginCompleted()
                        isLoading = false
                    case .failure(let error):
                        print(error.localizedDescription)
                        isLoading = false
                }
            }
        })
    }

    var goToRegister: some View {
        HStack {
            Spacer()
            Text("Don't have an account? You can")
                .font(Font.custom(FontManager.BaiJamjuree.regular, size: 14))
                .foregroundColor(.white)

            Button(action: {
               
            }, label: {
                Text("start with one here")
                    .foregroundColor(.white)
                    .font(.custom(FontManager.BaiJamjuree.semiBold, size: 14))
                    .bold()
                    .underline()
            })
            Spacer()
        }
        .padding(.bottom, 25)
    }
}

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        Login(onLoginCompleted: {})
    }
}
