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
