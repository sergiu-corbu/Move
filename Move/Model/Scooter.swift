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
    
    enum CodingKeys: String, CodingKey {
        case location = "location"
        case id = "_id"
        case battery = "power"
    }
}
