//
//  User.swift
//  Move
//
//  Created by Sergiu Corbu on 12.04.2021.
//

import Foundation

struct User: Codable {
    let email: String
    let username: String

    //var licenseConfirmed: Bool = false
    //var trips: [Trip] = []
    //let profileImage: Image = ""
    
    enum CodingKeys: String, CodingKey {
        case username = "username"
        case email = "email"
    }
}

struct AuthResult: Decodable {
    
    let user: User
    let token: String
    
    enum CodingKeys: String, CodingKey {
        case user = "user"
        case token = "token"
    }
}
