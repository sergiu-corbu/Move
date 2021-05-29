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

struct BasicResult: Codable {
	
	let message: String
	enum CodingKeys: String, CodingKey {
		case message = "message"
	}
}

struct APIError: Error, Decodable {
	
	var message: String
	var localizedDescription: String { return message }
	
	enum CodingKeys: String, CodingKey {
		case message = "message"
	}
}

struct UploadImage: Codable {
	
	let licenseKey: String
	
	enum CodingKeys: String, CodingKey {
		case licenseKey = "url"
	}
}
