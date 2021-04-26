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

struct MiniActionButton: View {
    let image: String
    let action: () -> Void
    
    var body: some View {
        
        Button(action: {
            action()
        }, label: {
            ZStack {
                RoundedRectangle(cornerRadius: 13)
                    .foregroundColor(.white)
                Image(image)
                    //.resizable()
            }
            .shadow(color: Color(UIColor.systemGray5), radius: 3, x: 5, y: 4)
            .frame(width: 36, height: 36)
        })
        
    }
}

struct UnlockButton: View {
    
    let text: String
    let action: () -> Void
    
    var body: some View {
        Button(action: {
            action()
        }, label: {
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.coralRed, lineWidth: 1.5)
                .frame(width: 95, height: 56)
                .background(Color.white)
                .overlay(
                    Text(text)
                        .foregroundColor(.coralRed)
                        .font(.custom(FontManager.Primary.bold, size: 14))
                )
        })
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
    let textColor: Color
    var error: String?
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
                        .foregroundColor(textColor)
                        .font(Font.custom(FontManager.Primary.medium, size: 18))
                        .autocapitalization(.none)
                        .accentColor(textColor)
                        .padding(.bottom, 10)
                        .padding(.top, 5)
                        .introspectTextField { textField in
                            textField.returnKeyType = .done
                        }
                        .disableAutocorrection(true)
                        .onTapGesture { action() }
                } else {
                    TextField(activeField ? "" : textField, text: $input)
                        .foregroundColor(textColor)
                        .font(Font.custom(FontManager.Primary.medium, size: 18))
                        .accentColor(textColor)
                        .autocapitalization(.none)
                        .padding(.bottom, 10)
                        .padding(.top, 5)
                        .introspectTextField { textField in
                            textField.returnKeyType = .next
                        }
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
                        }
                    }, label: {
                        if isSecuredField {
                            Image(showSecured ? "eye-img" : "eye-off-img")
                                .padding(.all, 5)
                                .foregroundColor(.fadePurple)
                        } else {
                            Image(image)
                                .padding(.all, 5)
                                .foregroundColor(.fadePurple)
                        }
                    })
                }
            }
            if let error = self.error {
                if activeField && !input.isEmpty && !error.isEmpty {
                Divider()
                    .padding(.bottom, 2)
                    .background(Color.errorRed)
                Text(error)
                    .foregroundColor(.errorRed)
                    .font(.custom(FontManager.Primary.regular, size: 14))
                } else if !activeField && !input.isEmpty && !error.isEmpty  {
                    Divider()
                        .padding(.bottom, 1)
                        .background(Color.errorRed)
                    Text(error)
                        .foregroundColor(.errorRed)
                        .font(.custom(FontManager.Primary.regular, size: 14))
                }
                else {
                    Divider()
                        .padding(.bottom, activeField ? 2 : 1)
                        .background(activeField ? Color.white : Color.fadePurple)
                }
            } else {
                Divider()
                    .padding(.bottom, activeField ? 2 : 1)
                    .background(activeField ? Color.white : Color.fadePurple)
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
        ZStack {
            if let _title = title {
                HStack {
                    Text(_title)
                        .font(.custom(FontManager.Primary.semiBold, size: 18))
                        .foregroundColor(.darkPurple)
                        .frame(maxWidth: .infinity)
                }
            }
            if let _avatar = avatar {
                HStack {
                    Spacer()
                    Image(_avatar)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 40, height: 40)
                }
            }
            HStack {
                Button(action: {
                    action()
                }, label: {
                    Image(backButton)
                        .padding(.trailing, 15)
                })
                Spacer()
            }
        }
    }
}

struct Reusable_Previews: PreviewProvider {
    static var previews: some View {
        //NavigationBar(title: "Driving License", avatar: "avatar-img", backButton: "chevron-left-purple", action: {})
        UnlockButton(text: "NFC", action: {
            
        })
    }
}

struct RoundedCorner: Shape {
    
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path{
        let path = UIBezierPath(roundedRect: rect,byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        
        return Path(path.cgPath)
    }
}


extension View{
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}
