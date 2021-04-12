//
//  User.swift
//  Move
//
//  Created by Sergiu Corbu on 12.04.2021.
//

import Foundation

struct User: Identifiable, Codable {
    let id: UUID
    let email: String
    let username: String
    let password: String
    var licenseConfirmed: Bool = false
    //var trips: [Trip] = []
    //let profileImage: Image = ""
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case username = "username"
        case email = "email"
        case password = "password"
    }
}

class UserViewModel: ObservableObject {
    
    init() {
        
    }
    // dowonlad user data from server
    //save info in userdefaults
}
