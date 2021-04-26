//
//  Helpers.swift
//  Move
//
//  Created by Sergiu Corbu on 4/7/21.
//

import Foundation

struct OnboardingData {
    let title: String
    let description: String
    let image: String
}

let onboardingData = [
    OnboardingData(title: "Safety", description: "Please wear a helmet and protect yourself while riding.", image: "Safety-img"),
    OnboardingData(title: "Scan", description: "Scan the QR code or NFC sticker on top of the scooter to unlock and ride.", image: "Scan-img"),
    OnboardingData(title: "Ride", description: "Step on the scooter with one foot and kick off the ground. When the scooter starts to coast, push the right throttle to accelerate.", image: "Ride-img"),
    OnboardingData(title: "Parking", description: "If convenient, park at a bike rack. If not, park close to the edge of the sidewalk closest to the street. Do not block sidewalks, doors or ramps.", image: "Parking-img"),
    OnboardingData(title: "Rules", description: "You must be 18 years or older with a valid driving licence to perate a scooter. Please follow all street signs, signals, markings and obey local traffic laws.", image: "Rules-img")
]
