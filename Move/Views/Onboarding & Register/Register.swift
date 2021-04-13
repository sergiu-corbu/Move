//
//  Register.swift
//  Move
//
//  Created by Sergiu Corbu on 4/7/21.
//

import SwiftUI
import Alamofire

struct Register: View {
    
    @State private var email: String = ""
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var termsPresented: Bool = false
    @State private var conditionsPresented: Bool = false
    
    @State private var emailTyping: Bool = false
    @State private var passwordTyping: Bool = false
    @State private var usernameTyping: Bool = false
     
    var allfieldsCompleted: Bool {
        return email != "" && username != "" && password != ""
    }
    
    var body: some View {
        ZStack {
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
            .background(Color.lightPurple)
            .edgesIgnoringSafeArea(.all)
            
            Image("Rectangle-img")
                .offset(x: 80, y: -290)
                .fixedSize()
            Image("Rectangle-img")
                .rotationEffect(.init(degrees: 180.0))
                .offset(x: -120, y: 290)
                .fixedSize()
        }
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
        HStack {
            Button(action: {
                API.register(username: username, email: email, password: password) { (result) in
                    switch result {
                    case .success(_):
                      print("success")
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            }, label: {
                HStack{
                    Spacer()
                    Text("Get started")
                        .foregroundColor(allfieldsCompleted ? .white : .fadePurple)
                        .font(allfieldsCompleted ? Font.custom(FontManager.BaiJamjuree.bold, size: 16)  : Font.custom(FontManager.BaiJamjuree.medium, size: 16))
                    Spacer()
                }
                .padding(.all, 20)
                .background(RoundedRectangle(cornerRadius: 16.0)
                .strokeBorder(Color.coralRed, lineWidth: 1)
                .background(RoundedRectangle(cornerRadius: 16.0).fill(allfieldsCompleted ? Color.coralRed : Color.clear))
                .opacity(allfieldsCompleted ? 1 : 0.3)
                
                )
                .disabled(!allfieldsCompleted)
            })
        }
        .padding([.top, .bottom], 20)
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
                    termsPresented.toggle()
                }, label: {
                    Text("Terms and Conditions")
                        .foregroundColor(.white)
                        .font(.custom(FontManager.BaiJamjuree.semiBold, size: 14))
                        .bold()
                        .underline()
                })
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
                //go to login
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
//        ForEach(["iPhone SE (2nd generation)", "iPhone 12"], id: \.self) { deviceName in
//            Register()
//                .previewDevice(PreviewDevice(rawValue: deviceName))
//                .previewDisplayName(deviceName)
//        }
//            .preferredColorScheme(.dark)
        Register()
            .preferredColorScheme(.dark)
    }
}
