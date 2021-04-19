//
//  ScooterViewModel.swift
//  Move
//
//  Created by Sergiu Corbu on 19.04.2021.
//

import Foundation

class ScooterViewModel: ObservableObject {
    @Published var allScooters: [Scooter] = []
}
