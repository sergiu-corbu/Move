//
//  Account.swift
//  Move
//
//  Created by Sergiu Corbu on 17.04.2021.
//

import SwiftUI

struct Account: View {
	
	@StateObject var userViewModel = UserViewModel()
	@State private var isActive: Bool = false
    
	let accountNavigation: (MenuNavigation) -> Void
    
    var body: some View {
        VStack(alignment: .leading) {
            NavigationBar(title: "Account", color: .darkPurple, backButton: "chevron-left-purple", action: {
				accountNavigation(.goBack)
			})
            inputArea
            Spacer()
            footerArea
        }
		.padding(.horizontal, 24)
		.background(Color.white.edgesIgnoringSafeArea(.all))
    }
    
    var inputArea: some View {
        VStack(alignment: .leading, spacing: 20) {
			CustomField(input: $userViewModel.username, activeField: isActive, textField: FieldType.username.rawValue, textColor: Color.darkPurple, upperTextOpacity: true)
			CustomField(input: $userViewModel.email, activeField: isActive, textField: FieldType.email.rawValue, textColor: Color.darkPurple, upperTextOpacity: true)
        }.padding(.top, 40)
    }
	
    var footerArea: some View {
        VStack(spacing: 50) {
            Button(action: {
				API.logout({ result in
					switch result {
						case .success:
							Session.tokenKey = nil
							accountNavigation(.logoutUser)
						case .failure(let error):
							showError(error: error.localizedDescription)
					}
				})
            }, label: {
				Label("Log out", image: "logout-img")
					.foregroundColor(.red)
					.font(.custom(FontManager.Primary.medium, size: 14))
            })
			Buttons.PrimaryButton(text: "Save edits", isLoading: userViewModel.isLoading, enabled:userViewModel.editCredentialsEnabled, action: {
				userViewModel.isLoading = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: { userViewModel.isLoading = false })
				accountNavigation(.goBack)
            })
			.padding(.bottom, 30)
        }
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
		Account { _ in }
	}
}
