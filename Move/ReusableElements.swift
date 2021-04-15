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
                            .font(enabled ? Font.custom(FontManager.BaiJamjuree.bold, size: 16) : Font.custom(FontManager.BaiJamjuree.medium, size: 16))
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
    }
}

struct Reusable_Previews: PreviewProvider {
    static var previews: some View {
        CallToActionButton(isLoading: true, enabled: true, text: "Get starferferf", action: {
            print("MMM")
        }).padding([.leading, .trailing], 24)
    }
}

//MARK: fields
struct InputField: View {
    
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
                    .font(Font.custom(FontManager.BaiJamjuree.regular, size: 14))
            }
            HStack {
                if showSecured && isSecuredField {
                    SecureField( activeField ? "" : textField, text: $input)
                        .foregroundColor(.white)
                        .font(Font.custom(FontManager.BaiJamjuree.medium, size: 18))
                        .accentColor(.white)
                        .padding(.bottom, 10)
                        .padding(.top, 5)
                        .disableAutocorrection(true)
                        .onTapGesture { action() }
                } else {
                    TextField( activeField ? "" : textField, text: $input)
                        .foregroundColor(.white)
                        .font(Font.custom(FontManager.BaiJamjuree.medium, size: 18))
                        .accentColor(.white)
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
            if isSecuredField && input == ""  && activeField {
                Text("Use a strong password (min. 8 characters and use symbols")
                    .font(.custom(FontManager.BaiJamjuree.regular, size: 13))
                    .foregroundColor(.white)
            }
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
                    .font(Font.custom(FontManager.BaiJamjuree.regular, size: 14))
            }
            HStack {
                TextField(activeField ? "" : text, text: $inputField)
                    .foregroundColor(.white)
                    .font(Font.custom(FontManager.BaiJamjuree.medium, size: 18))
                    .accentColor(.white)
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
