//
//  UserViewModel.swift
//  Move
//
//  Created by Sergiu Corbu on 13.04.2021.
//

import Foundation

class UserViewModel: ObservableObject {
	static var shared: UserViewModel = UserViewModel()
    //MARK: Register & Login
	@Published var email: String = "" {
        didSet {
            if email.isEmpty { emailError = "Email required"}
            else if !email.emailValidation() { emailError = "Invalid email"}
            else { emailError = ""}
        }
    }
    @Published var username: String = ""
    @Published var password: String = "" {
        didSet { isValidPassword() }
    }
	
	@Published var emailError = ""
	@Published var passwordError = ""
    
	//MARK: Reset password
    @Published var repeatPassword: String = "" {
		didSet {
			if password != repeatPassword { repeatPasswordError = "Passwords doesn't match!" }
			else { repeatPasswordError = "" }
		}
    }
	@Published var repeatPasswordError: String = ""
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
    
	//MARK: validation
    var resetPasswordEnabled: Bool { return email != "" }
    var allfieldsCompletedRegister: Bool { return email != "" && username != "" && password != "" && isLoading == false }
    var allfieldsValidatedRegister: Bool { return emailError.isEmpty && passwordError.isEmpty }
    var allfieldsCompletedLogin: Bool { return email != "" && password != "" && isLoading == false }
    var allfieldsValidatedLogin: Bool { return emailError.isEmpty && passwordError.isEmpty }
	var validatePasswords: Bool { return password != "" && repeatPassword != "" && passwordError.isEmpty && repeatPasswordError.isEmpty }
}
