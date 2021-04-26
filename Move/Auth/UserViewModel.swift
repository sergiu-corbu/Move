//
//  UserViewModel.swift
//  Move
//
//  Created by Sergiu Corbu on 13.04.2021.
//

import Foundation
import SwiftUI
import Combine

class UserViewModel: ObservableObject {
    
    @Published var email: String = "" {
        didSet {
            if email.isEmpty { emailError = "Email required"}
            else if !email.emailValidation() { emailError = "Invalid email"}
            else { emailError = ""}
        }
    }
    @Published var username: String = ""
    @Published var password: String = "" {
        didSet {
            isValidPassword()
        }
    }
    @Published var repeatPassword: String = "" {
        didSet {
            isValidPassword()
        }
    }
    @Published var isValid: Bool = false
    @Published var emailError = ""
    @Published var passwordError = ""
    
    func isValidPassword() {
        guard !password.isEmpty else {
            passwordError = "Password required"
            return
        }
        
        let showPasswordError = password.passwordValidation() == false
        
        if showPasswordError {
            if password.count < 6 {
                passwordError = "Must be at least 6 characters"
            } else if !password.isUpperCase() {
                passwordError = "Must contain at least one uppercase."
            } else if !password.isLowerCase() {
                passwordError = "Must contain at least one lowercase"
            } else if !password.containsCharacter() {
                passwordError = "Must contain at least one special character"
            } else if !password.containsDigit() {
                passwordError = "Must contain at least one digit"
            }
        } else {
            passwordError = ""
        }
    }
    
    // reset & forgot password
    // dowonlad user data from server
    //save info in userdefaults
}

extension String {
    
    func emailValidation() -> Bool {
        let emailRegex = "(?:[a-zA-Z0-9!#$%\\&‘*+/=?\\^_`{|}~-]+(?:\\.[a-zA-Z0-9!#$%\\&'*+/=?\\^_`{|}"
            + "~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
            + "x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"
            + "z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
            + "]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
            + "9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
            + "-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
        return NSPredicate(format: "SELF MATCHES[c] %@", emailRegex).evaluate(with: self)
    }
    
    func passwordValidation() -> Bool {
        let passwordRegex = "^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])[0-9a-zA-Z!@#$%^&*()\\-_=+{}|?>.<]{6,}$"
        return NSPredicate(format:"SELF MATCHES %@", passwordRegex).evaluate(with: self)
    }
    
    func isUpperCase() -> Bool {
        let uppercaseReqRegex = ".*[A-Z]+.*"
        return NSPredicate(format:"SELF MATCHES %@", uppercaseReqRegex).evaluate(with: self)
    }
    
    func isLowerCase() -> Bool {
        let lowercaseReqRegex = ".*[a-z]+.*"
        return NSPredicate(format:"SELF MATCHES %@", lowercaseReqRegex).evaluate(with: self)
    }
    
    func containsCharacter() -> Bool {
        let characterReqRegex = ".*[!@#$%^&*()\\-_=+{}|?>.<]+.*"
        return NSPredicate(format:"SELF MATCHES %@", characterReqRegex).evaluate(with: self)
    }
    
    func containsDigit() -> Bool {
        let digitReqRegex = ".*[0-9]+.*"
        return NSPredicate(format:"SELF MATCHES %@", digitReqRegex).evaluate(with: self)
    }
}
