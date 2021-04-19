//
//  Scooter.swift
//  Move
//
//  Created by Sergiu Corbu on 18.04.2021.
//

import Foundation

struct Coordinates {
    var latitude: Double
    var longitude: Double
}

struct Scooter: Identifiable{
    let id: String
    let battery: Double //get set?
    let location: Coordinates
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case battery = "power"
        case location = "location"
        
    }
}
