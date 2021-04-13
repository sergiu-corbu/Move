//
//  ReusableFields.swift
//  Move
//
//  Created by Sergiu Corbu on 13.04.2021.
//

import SwiftUI

struct InputField: View {
    
    @Binding var activeField: Bool
    @Binding var inputfield: String
    @State private var isSecured: Bool = false
    
    let fieldText: String
    let image: String
    let isSecuredField: Bool
    let action: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if  !inputfield.isEmpty || activeField {
                Text(fieldText)
                    .foregroundColor(.fadePurple)
                    .font(Font.custom(FontManager.BaiJamjuree.regular, size: 14))
            }
            HStack {
                if isSecuredField {
                    SecureField( activeField ? "" : fieldText, text: $inputfield)
                        .foregroundColor(.white)
                        .font(Font.custom(FontManager.BaiJamjuree.medium, size: 18))
                        .padding(.bottom, 10)
                        .padding(.top, 5)
                        .disableAutocorrection(true)
                        .onTapGesture { action() }
                } else {
                    TextField( activeField ? "" : fieldText, text: $inputfield)
                        .foregroundColor(.white)
                        .font(Font.custom(FontManager.BaiJamjuree.medium, size: 18))
                        .padding(.bottom, 10)
                        .padding(.top, 5)
                        .disableAutocorrection(true)
                        .onTapGesture {
                            activeField = true
                            action()
                        }
                }
                Spacer()
                if !inputfield.isEmpty {
                    Button(action: {
                        if isSecuredField {
                            isSecured.toggle()
                        } else {
                            inputfield = ""
                            activeField = false
                        }
                    }, label: {
                      //  if isSecuredField {
                       //     Image(isSecured ? "eye-img" : "close-img")
                      //          .padding(.all, 5)
                      //          .foregroundColor(.fadePurple)
                       // } else if !isSecuredField {
                            Image(image)
                                .padding(.all, 5)
                                .foregroundColor(.fadePurple)
                       // }
                        
                    })
                }
            }
            Divider()
                .padding(.bottom, activeField ? 2 : 1)
                .background(activeField ? Color.white : Color.fadePurple)
        }.padding([.top, .bottom], 6)
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
