//
//  Register.swift
//  Move
//
//  Created by Sergiu Corbu on 4/7/21.
//

import SwiftUI
import SafariServices
import Alamofire

let userDefault = UserDefaults.standard

struct Register: View {
    
    @State private var result: String = ""
    @State private var email: String = ""
    @State private var username: String = ""
    @State private var password: String = ""
    
    var allfieldsCompleted: Bool {
        return email != "" && username != "" && password != ""
    }
    
    var body: some View {
        ZStack {
            ScrollView(showsIndicators: false) {
                logoArea
                messageArea
                Text(result)
                    .font(.largeTitle)
                inputArea
                agreement
                getStartedButton
                goToLogin
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
            
            InputField(inputfield: $email, fieldText: "Email Address", image: "close-img", isSecuredField: false)
            InputField(inputfield: $username, fieldText: "Username", image: "close-img", isSecuredField: false)
            InputField(inputfield: $password, fieldText: "Password", image: "eye-img", isSecuredField: true)
        }
    }
    
    var getStartedButton: some View {
        HStack {
            Button(action: {
                API.register(username: username, email: email, password: password) { (result) in
                    switch result {
                    case .success(let user):
                        userDefault.setValue(username, forKey: user.username)
                        userDefault.setValue(email, forKey: user.email)
                        userDefault.setValue(password, forKey: user.password)
                        print(user.email)
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
              
            }, label: {
                Spacer()
                Text("Get started")
                    .foregroundColor(allfieldsCompleted ? .white : .fadePurple)
                    .font(allfieldsCompleted ? Font.custom(FontManager.BaiJamjuree.bold, size: 16)  : Font.custom(FontManager.BaiJamjuree.medium, size: 16))
                Spacer()
            })
            .padding(.all, 20)
            .background(RoundedRectangle(cornerRadius: 16.0)
                            .strokeBorder(Color.coralRed, lineWidth: 1)
                            .background(RoundedRectangle(cornerRadius: 16.0).fill(allfieldsCompleted ? Color.coralRed : Color.clear))
                            .opacity(allfieldsCompleted ? 1 : 0.3)
                        
            )
            .disabled(!allfieldsCompleted)
        }
        .padding([.top, .bottom], 20)
    }
    
    var agreement: some View {
        Text("By continuing you agree to Move’s")
            .foregroundColor(.white)
            +  Text(" and Privacy Policy")
    }
   
    var goToLogin: some View {
        HStack {
            Spacer()
            Text("You already have an account? You can log in here")
                .font(Font.custom(FontManager.BaiJamjuree.regular, size: 12))
                .foregroundColor(.white)
            Spacer()
        }
        .padding(.bottom, 25)
    }
}

struct Safarilink: View {
    @State var showSafari = false
    @State var urlString = "https://duckduckgo.com"
    
    var body: some View {
        Button(action: {
            self.urlString = "https://duckduckgo.com"
            self.showSafari = true
        }) {
            Text("Present Safari")
        }
        .sheet(isPresented: $showSafari) {
            SafariView(url:URL(string: self.urlString)!)
        }
    }
}

struct SafariView: UIViewControllerRepresentable {
    
    let url: URL
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<SafariView>) -> SFSafariViewController {
        return SFSafariViewController(url: url)
    }
    
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: UIViewControllerRepresentableContext<SafariView>) {
        
    }
    
}
 
struct InputField: View {
    @Binding var inputfield: String
    @State private var isTyping: Bool = false
    @State private var inputText: String = ""
    @State private var isSecured: Bool = false
    
    let fieldText: String
    let image: String
    let isSecuredField: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if isTyping || !inputText.isEmpty {
                Text(fieldText)
                    .foregroundColor(.fadePurple)
                    .font(Font.custom(FontManager.BaiJamjuree.regular, size: 12))
            }
            HStack {
                if isSecuredField {
                    SecureField( isTyping ? "" : fieldText, text: $inputfield)
                        .foregroundColor(.white)
                        .font(Font.custom(FontManager.BaiJamjuree.medium, size: 18))
                        .padding(.bottom, 25)
                        .onTapGesture(perform: {
                            isTyping = true
                        })
                } else {
                    TextField( isTyping ? "" : fieldText, text: $inputfield)
                        .foregroundColor(.white)
                        .font(Font.custom(FontManager.BaiJamjuree.medium, size: 18))
                        .padding(.bottom, 25)
                        .onTapGesture(perform: {
                            isTyping = true
                        })
                }
                Spacer()
                if !inputText.isEmpty {
                    Button(action: {
                        if isSecuredField {
                            isSecured.toggle()
                        } else {
                            inputText = ""
                            isTyping = false
                        }
                    }, label: {
                        if isSecuredField {
                            Image(isSecured ? "eye-img" : "close-img")
                                .padding(.all, 5)
                                .foregroundColor(.fadePurple)
                        } else if !isSecuredField {
                            Image(image)
                                .padding(.all, 5)
                                .foregroundColor(.fadePurple)
                        }
                        
                    })
                }
            }
            Divider()
                .padding(.bottom, isTyping ? 2 : 1)
                .background(isTyping ? Color.white : Color.fadePurple)
        }.padding(.bottom, 12)
    }
}

struct Register_Previews: PreviewProvider {
    static var previews: some View {
      //  ForEach(["iPhone SE (2nd generation)", "iPhone 12"], id: \.self) { deviceName in
            Register()
          //      .previewDevice(PreviewDevice(rawValue: deviceName))
        //        .previewDisplayName(deviceName)
       // }
            .preferredColorScheme(.dark)
    }
}
