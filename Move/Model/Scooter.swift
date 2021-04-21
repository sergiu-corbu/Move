//
//  Scooter.swift
//  Move
//
//  Created by Sergiu Corbu on 18.04.2021.
//

import Foundation

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
    let battery: Double
    let location: Location
    var batteryPercentage: String {
        return "\((battery * 100).clean)%"
    }
    var batteryImage: String {
        let _battery = battery * 100
        var _batteryImage: String = ""
        if _battery <= 5 {
           _batteryImage = "discharged-battery"
        } else if _battery <= 40 {
            _batteryImage = "almostEmpty-battery"
        } else if _battery <= 60 {
            _batteryImage = "half-battery"
        } else if _battery <= 80 {
            _batteryImage = "almostFull-battery"
        } else if _battery <= 100 {
            _batteryImage = "full-battery"
        }
        return _batteryImage
    }
    
    enum CodingKeys: String, CodingKey {
        case location = "location"
        case id = "_id"
        case battery = "power"
    }
}
