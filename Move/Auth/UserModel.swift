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
/*
struct Trip: Codable {
	
	let startTime: String
	let endTime: String
	let startLocation: Double
	let finishLocation: Double
	let ongoing: Bool
	let path: []
	
	enum CodingKeys: String, CodingKey {
		case startLocation = "Starlocation"
		case finishLocation = "finish"
		case travelTime = "traveltime"
		case distance = "distance"
	}
}

struct TripsDataModel: Codable {
	//let username: String
	let trips: Trip
	
	enum CodingKeys: String, CodingKey {
		//case username = "username"
		case trips = "trips"
	}
}
*/
