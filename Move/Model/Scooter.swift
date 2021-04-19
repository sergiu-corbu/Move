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
    let battery: Double //get set?
    let location: Location
    let v: Int
    
    enum CodingKeys: String, CodingKey {
        case location = "location"
        case id = "_id"
        case battery = "power"
        case v = "__v"
    }
}
