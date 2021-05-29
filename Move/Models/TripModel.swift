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

struct StartTrip: Codable {
	
	let trip: TripDecoding
	
	enum CodingKeys: String, CodingKey {
		case trip = "booking"
	}
	
	struct TripDecoding: Codable {
		
		let path: [[Double]]
		enum CodingKeys: String, CodingKey {
			case path = "path"
		}
	}
}

struct OngoingTrip: Codable {
	
	var ongoingTrip: CurrentTripDecoding = CurrentTripDecoding()
	
	enum CodingKeys: String, CodingKey {
		case ongoingTrip = "booking"
	}
	
	struct CurrentTripDecoding: Codable {
		var distance: Double = 0
		var tripId: String = ""
		var scooterId: String = ""
		var path: [[Double]] = []
		var startDate: String = ""
		
		enum CodingKeys: String, CodingKey {
			case scooterId = "scooterId"
			case distance = "distance"
			case path = "path"
			case startDate = "startDate"
			case tripId = "_id"
		}
	}
}

struct EndTrip: Codable {
	
	var endTrip: EndTripDecoding = EndTripDecoding()
	
	enum CodingKeys: String, CodingKey {
		case endTrip = "booking"
	}
	
	struct EndTripDecoding: Codable {
		
		var path: [[Double]] = []
		var scooterId: String = ""
		var startDate: String = ""
		var endDate: String = ""
		var startStreet: String = ""
		var endStreet: String = ""
		var duration: String = ""
		var distance: Double = 0
		var price: Double?
		
		enum CodingKeys: String, CodingKey {
			case path = "path"
			case scooterId = "scooterId"
			case startDate = "startDate"
			case endDate = "endDate"
			case startStreet = "startAddress"
			case endStreet = "endAddress"
			case duration = "duration"
			case distance = "distance"
			case price = "totalPrice"
		}
	}
}

struct TripLocation: Identifiable {
	let id = UUID()
	let coordinates: CLLocationCoordinate2D
	let image: Image
}

struct TripsHistory: Codable {
	let trips: [Booking]
	
	enum CodingKeys: String, CodingKey {
		case trips = "bookings"
	}
	
	struct Booking: Codable {
		let startStreet: String
		let endStreet: String
		let distance: Double
		let tripTime: String
		
		enum CodingKeys: String, CodingKey {
			case startStreet = "startAddress"
			case endStreet = "endAddress"
			case distance = "distance"
			case tripTime = "duration"
		}
	}
}
