//
//  Scooter.swift
//  Move
//
//  Created by Sergiu Corbu on 18.04.2021.
//

import Foundation
import CoreLocation

struct Location: Codable, Hashable {
    let coordinates: [Double]
    let type: String
    
    enum codingKeys: String, CodingKey {
        case coordinates = "coordinates"
        case type = "type"
    }
}

struct Scooter: Identifiable, Codable, Equatable, Hashable {
	static func == (lhs: Scooter, rhs: Scooter) -> Bool {
		return true
	}

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
	var scooterLocation: CLLocation {
		return CLLocation(latitude: location.coordinates[1], longitude: location.coordinates[0])
	}
	
	var isInCluster: Bool = false
	
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

struct Cluster: Identifiable {
	var id = UUID()
	var scooters: [Scooter] = []
	var latitude: Double {
		var median: Double = 0
		for scooter in scooters {
			median += scooter.coordinates.latitude
		}
		return median / Double(scooters.count)
	}
	
	var longitude: Double {
		var median: Double = 0
		for scooter in scooters {
			median += scooter.coordinates.longitude
		}
		return median / Double(scooters.count)
	}
}

struct LockUnlockResult: Codable {
	
	let scooter: Scooter
	
	enum CodingKeys: String, CodingKey {
		case scooter = "scooter"
	}
}

struct Ping: Codable {
	
	let ping: Bool
	
	enum CodingKeys: String, CodingKey {
		case ping = "ping"
	}
}

