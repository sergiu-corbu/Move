//
//  UserViewModel.swift
//  Move
//
//  Created by Sergiu Corbu on 13.04.2021.
//

import Foundation

enum ValidationError: Error {
    case notDefined
}

class UserViewModel: ObservableObject {
    @Published var email: String
    @Published var username: String
    @Published var password: String
    init() {
        email = ""
        username = ""
        password = ""
    }
    
    func register(_ callback: @escaping () -> Void ) {
        
    }
    // dowonlad user data from server
    //save info in userdefaults
}
