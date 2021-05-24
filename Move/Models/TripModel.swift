//
//  TripModel.swift
//  Move
//
//  Created by Sergiu Corbu on 05.05.2021.
//
import Foundation
import CoreLocation
import SwiftUI
import MapKit

struct Trip: Codable {
	
	let startStreet: String
	let endStreet: String
	let duration: Int
	let distance: Float
	let ongoing: Bool
	
	enum CodingKeys: String, CodingKey {
		case startStreet = "startStreet"
		case endStreet = "endStreet"
		case duration = "duration"
		case distance = "totalDistance"
		case ongoing = "ongoing"
	}
}

struct TripResult: Codable {
	
	var trips: [Trip]
	var totalTrips: Int
	
	enum CodingKeys: String, CodingKey {
		case trips = "trips"
		case totalTrips = "totalTrips"
	}
}

struct StartTrip: Codable {
	
	let trip: TripDecoding
	
	enum CodingKeys: String, CodingKey {
		case trip = "trip"
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
}

struct EndTripResult: Codable {
	
	let trip: EndTrip
	
	struct EndTrip: Codable {
		
		let duration: Int
		let totalDistance: Int
		let price: Int
		
		enum CodingKeys: String, CodingKey {
			case duration = "duration"
			case totalDistance = "totalDistance"
			case price = "price"
		}
	}
	
	enum CodingKeys: String, CodingKey {
		case trip = "trip"
	}
}

struct OngoingTripDecoding: Codable {
	
	var ongoing: Bool
	var path: [[Double]]
	let scooter: Scooter
	
	enum CodingKeys: String, CodingKey {
		case path = "path"
		case ongoing = "ongoing"
		case scooter = "scooter"
	}
}

struct OngoingTrip: Codable {
	
	var trip: OngoingTripDecoding
	var distance: Int
	var duration: Int
	
	var distanceString: String {
		return String(distance)
	}
	
	enum CodingKeys: String, CodingKey {
		case trip = "trip"
		case duration = "duration"
		case distance = "distance"
	}
}

struct TripLocation: Identifiable {
	let id = UUID()
	let coordinates: CLLocationCoordinate2D
	let image: Image
}

struct TripModel {
	var time: Int = 0
	var distance: Int = 0
	var ongoing: Bool = false
	var tripScooter: Scooter?
	var price: Int = 0
	var startStreet: String = ""
	var endStreet: String = ""
	var allTrips: [Trip] = []
	var tripRegion: MKCoordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 46.74834800, longitude: 23.58783800), latitudinalMeters: 1400, longitudinalMeters: 1400)
	var path: [[Double]] = []
}
