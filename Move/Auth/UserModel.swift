//
//  User.swift
//  Move
//
//  Created by Sergiu Corbu on 12.04.2021.
//

import Foundation

struct UserModel: Codable {
    let email: String
    let username: String
    //var trips: [Trip] = []
    //let profileImage: Image = ""
    
    enum CodingKeys: String, CodingKey {
        case username = "username"
        case email = "email"
    }
}

struct AuthResult: Decodable {
    
    let user: UserModel
    let token: String
    
    enum CodingKeys: String, CodingKey {
        case user = "user"
        case token = "token"
    }
}
