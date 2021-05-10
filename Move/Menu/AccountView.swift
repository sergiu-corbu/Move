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
            NavigationBar(title: "Account", color: .darkPurple, backButton: "chevron-left-purple", action: { onBack() })
            inputArea
            Spacer()
            footerArea
        }
		.padding(.horizontal, 24)
        .background(Color.white)
    }
    
    var inputArea: some View {
        VStack(alignment: .leading, spacing: 20) {
			InputField(input: $username, activeField: usernameActive, textField: InputFieldType.username.rawValue, textColor: Color.darkPurple)
			InputField(input: $email, activeField: emailActive, textField: InputFieldType.email.rawValue, textColor: Color.darkPurple)
        }.padding(.top, 40)
    }
	
    var footerArea: some View {
        VStack(spacing: 50) {
            Button(action: {
                API.logout() { result in
					switch result {
						case true:
							Session.tokenKey = nil
							onLogout()
						case false: showError(error: "Error from server")
					}
                }
            }, label: {
				Label("Log out", image: "logout-img")
					.foregroundColor(.red)
					.font(.custom(FontManager.Primary.medium, size: 14))
            })
            ActionButton(isLoading: isLoading, enabled: allFiledsCompleted, text: "Save edits", action: {
                isLoading = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: { isLoading = false })
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
