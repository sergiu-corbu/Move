//
//  UserViewModel.swift
//  Move
//
//  Created by Sergiu Corbu on 13.04.2021.
//

import Foundation
import SwiftUI
import NavigationStack

class UserViewModel: ObservableObject {
	@EnvironmentObject var navigationStack: NavigationStack
	static var shared: UserViewModel = UserViewModel()
    //MARK: Register & Login
	@Published var email: String = "sergiu_@icloud.com"
    @Published var username: String = ""
    @Published var password: String = "123456Ss"
	@Published var emailError = ""
	@Published var passwordError = ""
    
	//MARK: Reset password
	@Published var newPassword: String = ""
	@Published var newPasswordError: String = ""
	@Published var isActive: Bool = false
	@Published var isLoading: Bool = false
	
    func isValidPassword() {
        guard !password.isEmpty else { passwordError = "Password required"; return }
        let showPasswordError = password.passwordValidation() == false
        if showPasswordError {
			if password.count < 6 { passwordError = "Must be at least 6 characters"
            } else if !password.isUpperCase() { passwordError = "Must contain at least one uppercase."
            } else if !password.isLowerCase() { passwordError = "Must contain at least one lowercase"
            } else if !password.containsCharacter() { passwordError = "Must contain at least one special character"
            } else if !password.containsDigit() { passwordError = "Must contain at least one digit" }
        } else { passwordError = "" }
    }
	
	func validateFields() {
		if email.isEmpty { emailError = "Email required"}
		else if !email.emailValidation() { emailError = "Invalid email"}
		else { emailError = "" }
		isValidPassword()
	}
	
	func registerCall(_ callback: @escaping () -> Void) {
		 API.registerUser(email: email, password: password, username: username) { result in
			switch result {
				case .success(let result):
					Session.tokenKey = result.token
					Session.username = result.user.username
					callback()
				case .failure(let error):
					showError(error: error.localizedDescription)
					self.clearFields()
			}
			self.isLoading = false
		}
	}
	
	func loginCall(_ callback: @escaping () -> Void) {
		API.loginUser(email: email, password: password) { result in
			switch result {
				case .success(let result):
					Session.tokenKey = result.token
					Session.username = result.user.username
					callback()
				case .failure(let error):
					break
//					checkFor401(failureMessage: error.localizedDescription) { isSuspended in
//						print(isSuspended)
//						if isSuspended {
//							self.navigationStack.push(ContentView())
//						} else {
//							self.clearFields()
//							showError(error: error.localizedDescription)
//						}
//					}
					
			}
			self.isLoading = false
		}
	}
	
	func resetPasswordCall(_ callback: @escaping () -> Void) {
		API.resetPassword(oldPassword: password, newPassword: newPassword) { result in
			switch result {
				case .success:
					showMessage(message: "Password reset successful")
				case .failure(let error):
					showError(error: error.localizedDescription)
			}
		}
	}
	
	private func clearFields() {
		username = ""
		password = ""
		email = ""
	}
    
	//MARK: validation
	var editCredentialsEnabled: Bool { return email != "" && username != ""}
    var resetPasswordEnabled: Bool { return email != "" }
	var allfieldsCompletedRegister: Bool { return email != "" && username != "" && password.count > 5 && isLoading == false }
    var allfieldsValidatedRegister: Bool { return emailError.isEmpty && passwordError.isEmpty }
	var allfieldsCompletedLogin: Bool { return email != "" && password.count > 5 && isLoading == false }
    var allfieldsValidatedLogin: Bool { return emailError.isEmpty && passwordError.isEmpty }
	var validatePasswords: Bool { return password != "" && newPassword != "" && passwordError.isEmpty && newPasswordError.isEmpty }
}
