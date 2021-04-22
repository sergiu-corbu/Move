//
//  AccountView.swift
//  Move
//
//  Created by Sergiu Corbu on 17.04.2021.
//

import SwiftUI

struct AccountView: View {
    
    @State private var username: String = ""
    @State private var email: String = ""
    @State private var usernameActive: Bool = false
    @State private var emailActive: Bool = false
    @State private var isLoading: Bool = false
    
    let onBack: () -> Void
    let onLogout: () -> Void
    let onSave: () -> Void
    
    var allFiledsCompleted: Bool {
        return username != "" && email != ""
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            NavigationBar(title: "Account", avatar: nil, backButton: "chevron-left-purple", action: { onBack() })
                .padding(.top, 60)
            inputArea
            Spacer()
            footerArea
        }
        .padding([.leading, .trailing], 24)
        .edgesIgnoringSafeArea(.all)
        .background(Color.white)
        
    }
    
    var inputArea: some View {
        
        VStack(alignment: .leading, spacing: 20) {
            InputField(activeField: $usernameActive, input: $username, textField: "Username", image: "", isSecuredField: false, textColor: Color.darkPurple, action: {
                usernameActive = true
                emailActive = false
            })
            InputField(activeField: $emailActive, input: $email, textField: "Email Address", image: "", isSecuredField: false, textColor: Color.darkPurple, action: {
                usernameActive = false
                emailActive = true
            })
        }.padding(.top, 50)
    }
    var footerArea: some View {
        VStack(spacing: 50) {
            Button(action: {
                onLogout()
            }, label: {
                HStack {
                    Image("logout-img")
                    Text("Log out")
                        .foregroundColor(.red)
                        .font(.custom(FontManager.Primary.medium, size: 14))
                }
            })
            CallToActionButton(isLoading: isLoading, enabled: allFiledsCompleted, text: "Save edits", action: {
                isLoading = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                    isLoading = false
                })
                onSave()
            }).padding(.bottom, 30)
        }
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView(onBack: {}, onLogout: {}, onSave: {})
    }
}
