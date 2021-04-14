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
    
    @State private var email: String = ""
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var emailTyping: Bool = false
    @State private var passwordTyping: Bool = false
    @State private var usernameTyping: Bool = false
    
    @State private var termsPresented: Bool = false
    @State private var conditionsPresented: Bool = false
    @State private var isLoading: Bool = false
    @ObservedObject var navigationViewModel: NavigationStack = NavigationStack()
    
    let onRegisterComplete: () -> Void

    var allfieldsCompleted: Bool {
        return email != "" && username != "" && password != "" && isLoading == false
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            logoArea
            messageArea
            inputArea
            agreement
            getStartedButton
            goToLogin
            Spacer()
        }
        .padding([.leading, .trailing], 24)
        .background(
            Image("rect-background-img")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
        )
      //  .edgesIgnoringSafeArea(.all)
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
                Text("Let's get started")
                    .foregroundColor(.white)
                    .font(Font.custom(FontManager.BaiJamjuree.bold, size: 32))
                Spacer()
            }
            .padding(.bottom, 15)
            
            HStack {
                Text("Sign up or login and start\nriding right away")
                    .foregroundColor(.white)
                    .font(Font.custom(FontManager.BaiJamjuree.medium, size: 20))
                    .opacity(0.6)
                    .lineSpacing(3)
                    .frame(height: 55)
                Spacer()
            }
            .padding(.bottom, 5)
        }
    }
    
    var inputArea: some View {
        VStack(alignment: .leading) {
            InputField(activeField: $emailTyping, input: $email, textField: "Email Address", image: "close-img", isSecuredField: false, action: {
                emailTyping = true
                usernameTyping = false
                passwordTyping = false
            })
            InputField(activeField: $usernameTyping, input: $username, textField: "Username", image: "close-img", isSecuredField: false, action: {
                emailTyping = false
                usernameTyping = true
                passwordTyping = false
            })
            InputField(activeField: $passwordTyping, input: $password, textField: "Password", image: "eye-img", isSecuredField: true, action: {
                emailTyping = false
                usernameTyping = false
                passwordTyping = true
            })
        }
    }
    
    var getStartedButton: some View {
        
        CallToActionButton(isLoading: isLoading, enabled: allfieldsCompleted, text: "Get started", action: {
            isLoading = true
            API.register(username: username, email: email, password: password) { (result) in
                switch result {
                    case .success:
                        onRegisterComplete()
                        isLoading = false
                    case .failure(let error):
                        print(error.localizedDescription)
                        isLoading = false
                }
            }
        })
    }
    
    var agreement: some View {
        VStack {
            HStack {
                Text("By continuing you agree to Move’s")
                    .foregroundColor(.white)
                    .font(.custom(FontManager.BaiJamjuree.medium, size: 14))
                Spacer()
            }
            HStack {
                Button(action: {
                    termsPresented = true
                }, label: {
                    Text("Terms and Conditions")
                        .foregroundColor(.white)
                        .font(.custom(FontManager.BaiJamjuree.semiBold, size: 14))
                        .bold()
                        .underline()
                })
                .safariView(isPresented: $termsPresented) {
                    SafariView(url: URL(string: "https://tapptitude.com")!, configuration: SafariView.Configuration(entersReaderIfAvailable: false, barCollapsingEnabled: true))
                        .dismissButtonStyle(.close)
                }
                Text("and")
                    .foregroundColor(.white)
                    .font(.custom(FontManager.BaiJamjuree.medium, size: 14))
                    .padding([.trailing, .leading], -3)
                Button(action: {
                    
                }, label: {
                    Text("Privacy Policy")
                        .foregroundColor(.white)
                        .font(.custom(FontManager.BaiJamjuree.semiBold, size: 14))
                        .bold()
                        .underline()
                })
                .safariView(isPresented: $termsPresented) {
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
            Spacer()
            Text("You already have an account? You can")
                .font(Font.custom(FontManager.BaiJamjuree.regular, size: 14))
                .foregroundColor(.white)

            Button(action: {
                /*NavigationStackView(navigationStack: navigationViewModel) {
                    Register(onRegisterComplete: {}) {
                        navigationViewModel.push(Login(onLoginCompleted: {
                            navigationViewModel.push(MapView())
                        }))
                    }
                    
                }*/
            }, label: {
                Text("log in here")
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

struct Register_Previews: PreviewProvider {
    static var previews: some View {
        //"iPhone SE (2nd generation)",
        ForEach(["iPhone 12"], id: \.self) { deviceName in
            Register(onRegisterComplete: {})
                .previewDevice(PreviewDevice(rawValue: deviceName))
                .previewDisplayName(deviceName)
        }
        .preferredColorScheme(.dark)
        //Register(onRegisterComplete: {})
          //  .preferredColorScheme(.dark)
    }
}
