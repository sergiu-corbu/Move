//
//  ResultModels.swift
//  Move
//
//  Created by Sergiu Corbu on 17.05.2021.
//

import Foundation


struct TripDownload: Codable {
	var trips: [Trip]
	var totalTrips: Int
	
	enum CodingKeys: String, CodingKey {
		case trips = "trips"
		case totalTrips = "totalTrips"
	}
}

struct Logout: Codable {
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

struct TripDecoding: Codable {
	let path: [[Double]]
	let startTime: String
	let ongoing: Bool
	
	enum CodingKeys: String, CodingKey {
		case path = "path"
		case startTime = "startTime"
		case ongoing = "ongoing"
	}
}
struct StartTrip: Codable {
	let trip: TripDecoding
	
	enum CodingKeys: String, CodingKey {
		case trip = "trip"
	}
}

struct EndTripResult: Codable {
	let trip: EndTrip
	
	struct EndTrip: Codable {
		let startTime: String
		let endTime: String
		let ongoing: Bool
		
		enum CodingKeys: String, CodingKey {
			case startTime = "startTime"
			case endTime = "endTime"
			case ongoing = "ongoing"
		}
	}

	enum CodingKeys: String, CodingKey {
		case trip = "trip"
	}
}

struct CurrentTrip: Codable {
	var distance: Int
	var distanceString: String {
		return String(distance)
	}
	enum CodingKeys: String, CodingKey {
		case distance = "distance"
	}
}

struct Ping: Codable {
	let ping: Bool
	enum CodingKeys: String, CodingKey {
		case ping = "ping"
	}
}
