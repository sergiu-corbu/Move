//
//  TripModel.swift
//  Move
//
//  Created by Sergiu Corbu on 05.05.2021.
//

import Foundation

struct Trip: Codable, Hashable {
	
	let user: String
	let scooter: String
	let startTime: String
	let endTime: String
	let ongoing: Bool
	let path: [[Double]]
	
	enum CodingKeys: String, CodingKey {
		case user = "user"
		case scooter = "scooter"
		case startTime = "startTime"
		case endTime = "endTime"
		case ongoing = "ongoing"
		case path = "path"
	}
}
