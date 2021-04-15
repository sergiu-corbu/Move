//
//  UserViewModel.swift
//  Move
//
//  Created by Sergiu Corbu on 13.04.2021.
//

import Foundation

enum EmailValidator {
    case empty
    case invalidFormat
    case valid
}

enum PasswordValidator {
    case empty
    case notStrongEnough
    case valid
}

class UserViewModel: ObservableObject {
    
    @Published var email: String = ""
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var isValid: Bool = false
    
   

    // dowonlad user data from server
    //save info in userdefaults
}
