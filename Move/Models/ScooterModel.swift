//
//  Scooter.swift
//  Move
//
//  Created by Sergiu Corbu on 18.04.2021.
//

import Foundation
import CoreLocation

struct Location: Codable {
    let coordinates: [Double]
    let type: String
    
    enum codingKeys: String, CodingKey {
        case coordinates = "coordinates"
        case type = "type"
    }
}

struct Scooter: Identifiable, Codable {
	
	let id: String
    let location: Location
	let available: Bool
    let locked: Bool
	let deviceKey: String
    let battery: Int
	
    var addressName: String?
    var coordinates: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: location.coordinates[1], longitude: location.coordinates[0])
    }
	var isSelected: Bool = false
	
    var batteryImage: String {
        var batteryImage: String = ""
        if battery <= 5 {
            batteryImage = "discharged-battery"
        } else if battery <= 40 {
            batteryImage = "almostEmpty-battery"
        } else if battery <= 60 {
            batteryImage = "half-battery"
        } else if battery <= 80 {
            batteryImage = "almostFull-battery"
        } else if battery <= 100 {
            batteryImage = "full-battery"
        }
        return batteryImage
    }
    
    enum CodingKeys: String, CodingKey {
		case id = "tag"
        case location = "location"
		case available = "available"
		case locked = "locked"
		case deviceKey = "deviceKey"
        case battery = "power"
    }
}

struct LockUnlockResult: Codable {
	
	let scooter: Scooter
	
	enum CodingKeys: String, CodingKey {
		case scooter = "scooter"
	}
}

struct CurrentTrip: Codable {
	
	var ongoing: Bool
	let scooter: Scooter
	
	enum CodingKeys: String, CodingKey {
		case ongoing = "ongoing"
		case scooter = "scooter"
	}
}

struct CurrentTripResult: Codable {
	
	var trip: CurrentTrip
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

struct Ping: Codable {
	
	let ping: Bool
	
	enum CodingKeys: String, CodingKey {
		case ping = "ping"
	}
}

