//
//  Reusable Buttons.swift
//  Move
//
//  Created by Sergiu Corbu on 4/11/21.
//

import SwiftUI

//MARK: buttons

struct CallToActionButton: View {
    
    var isLoading: Bool? = false
    var enabled: Bool = false
    let text: String
    let action: () -> Void
    
    var body: some View {
        HStack {
            Button(action: {
                action()
            }, label: {
                ZStack(alignment: .trailing) {
                    HStack {
                        Text(text)
                            .foregroundColor(enabled ? .white : .fadePurple)
                            .font(enabled ? Font.custom(FontManager.Primary.bold, size: 16) : Font.custom(FontManager.Primary.medium, size: 16))
                            .frame(maxWidth: .infinity)
                            .padding([.trailing, .leading], 46)
                    }
                    .padding(.all, 20)
                    .background(RoundedRectangle(cornerRadius: 16.0)
                                    .strokeBorder(Color.coralRed, lineWidth: 1)
                                    .background(RoundedRectangle(cornerRadius: 16.0).fill(enabled ? Color.coralRed : Color.clear))
                                    .opacity(enabled ? 1 : 0.3)
                    )
                    if let _isLoading = isLoading {
                        if _isLoading == true {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .scaleEffect(1.5)
                                .frame(width: 30, height: 30)
                                .padding(.trailing, 16)
                        }
                    }
                }
            })
            .disabled(!enabled)
        }
        .padding(.bottom, 20)
    }
}

//MARK: fields
struct InputField: View {
    @StateObject private var userViewModel = UserViewModel()
    @Binding var activeField: Bool
    @Binding var input: String
    @State private var showSecured: Bool = true
    
    let textField: String
    let image: String
    let isSecuredField: Bool
    let action: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if  !input.isEmpty || activeField {
                Text(textField)
                    .foregroundColor(.fadePurple)
                    .font(Font.custom(FontManager.Primary.regular, size: 14))
            }
            HStack {
                if showSecured && isSecuredField {
                    SecureField(activeField ? "" : textField, text: $input)
                        .foregroundColor(.white)
                        .font(Font.custom(FontManager.Primary.medium, size: 18))
                        .autocapitalization(.none)
                        .accentColor(.white)
                        .padding(.bottom, 10)
                        .padding(.top, 5)
                        .disableAutocorrection(true)
                        .onTapGesture { action() }
                } else {
                    TextField(activeField ? "" : textField, text: $input)
                        .foregroundColor(.white)
                        .font(Font.custom(FontManager.Primary.medium, size: 18))
                        .accentColor(.white)
                        .autocapitalization(.none)
                        .padding(.bottom, 10)
                        .padding(.top, 5)
                        .disableAutocorrection(true)
                        .onTapGesture {
                            activeField = true
                            action()
                        }
                }
                Spacer()
                if !input.isEmpty && activeField {
                    Button(action: {
                        if isSecuredField { showSecured.toggle() } else {
                            input = ""
                            activeField = false
                        }
                    }, label: {
                        if isSecuredField {
                            Image(showSecured ? "eye-img" : "eye-off-img")
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
                .padding(.bottom, activeField ? 2 : 1)
                .background(activeField ? Color.white : Color.fadePurple)
            
         /*   if !isSecuredField {
                if !self.userViewModel.emailValidation.evaluate(with: userViewModel.email) {
                    Text("errorrr")
                        .foregroundColor(.coralRed)
                        .font(.footnote)
                }
            } else*/
            if isSecuredField && input == ""  && activeField {
                Text("Use a strong password (min. 8 characters and use symbols")
                    .font(.custom(FontManager.Primary.regular, size: 13))
                    .foregroundColor(.white)
            } /*else if isSecuredField && input != "" && activeField  {
                if !self.userViewModel.passwordValidation.evaluate(with: userViewModel.password) {
                Text("password errorrr")
                    .foregroundColor(.coralRed)
                    .font(.footnote)
                }
            }*/
            
        }
        .padding([.top, .bottom], 6)
        .edgesIgnoringSafeArea(.bottom)
    }
}

struct InputPasswordReset: View {
    
    @Binding var activeField: Bool
    @Binding var inputField: String
    
    let text: String
    let action: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if activeField || !inputField.isEmpty {
                Text(text)
                    .foregroundColor(.fadePurple)
                    .font(Font.custom(FontManager.Primary.regular, size: 14))
            }
            HStack {
                TextField(activeField ? "" : text, text: $inputField)
                    .foregroundColor(.white)
                    .font(Font.custom(FontManager.Primary.medium, size: 18))
                    .accentColor(.white)
                    .autocapitalization(.none)
                    .padding(.bottom, 10)
                    .padding(.top, 5)
                    .disableAutocorrection(true)
                    .onTapGesture {
                        activeField = true
                        action()
                    }
                Spacer()
            }
            Divider()
                .padding(.bottom, activeField ? 2 : 1)
                .background(activeField ? Color.white : Color.fadePurple)
        }.padding(.bottom, 12)
    }
}

// MARK: navigation bar

struct NavigationBar: View {
    let title: String?
    let avatar: String?
    let backButton: String
    let action: () -> Void
    
    var body: some View {
        HStack {
            Button(action: {
                action()
            }, label: {
                Image(backButton)
            })
            if let _title = title {
                Text(_title)
                    .font(.custom(FontManager.Primary.semiBold, size: 18))
                    .foregroundColor(.darkPurple)
                    .frame(maxWidth: .infinity)
                  //  .padding(.trailing, 24)
            }
            Spacer()
            if let _avatar = avatar {
                Image(_avatar)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 40, height: 40)
                
            }
        }
    }
}

struct Reusable_Previews: PreviewProvider {
    static var previews: some View {
        NavigationBar(title: "Driving License", avatar: nil, backButton: "chevron-left-purple", action: {})
    }
}
