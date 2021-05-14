//
//  ScooterViewModel.swift
//  Move
//
//  Created by Sergiu Corbu on 19.04.2021.
//

import Foundation
import CoreLocation

//class ScooterViewModel: ObservableObject {
//	
//    @Published var allScooters: [Scooter] = []
//    var location: CLLocationCoordinate2D? {
//        didSet { if oldValue == nil { reloadData() } }
//    }
//    
//    private func reloadData() {
//        getAvailableScooters()
//        DispatchQueue.main.asyncAfter(deadline: .now() + 30, execute: { self.reloadData() })
//    }
//    
//    func getAvailableScooters() {
//        guard let location = self.location else { return }
//        API.getScooters(coordinates: location) { result in
//            switch result {
//                case .success(let scooters):
//                    self.allScooters = scooters
//                case .failure(let error):
//                    print(error.localizedDescription)
//            }
//        }
//    }
//}
