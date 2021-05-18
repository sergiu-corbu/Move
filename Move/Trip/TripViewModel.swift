//
//  TripViewModel.swift
//  Move
//
//  Created by Sergiu Corbu on 06.05.2021.
//

import Foundation
import SwiftUI

class TripViewModel: ObservableObject {
	@ObservedObject var mapViewModel: MapViewModel = MapViewModel.shared
	@Published var currentTrip: CurrentTripResult?
	@Published var tripCount: Int = 0
	static var shared: TripViewModel = TripViewModel()
	var allTrips: [Trip] = []
	
	init() {
		downloadTrips()
	}
	
	func downloadTrips() {
		API.downloadTrips( { result in
			switch result {
				case .success(let trips):
					self.allTrips = trips.trips
					self.tripCount = trips.totalTrips
				case .failure(let error): showError(error: error.localizedDescription)
			}
		})
	}
	
	func updateTrip() {
		API.updateTrip { result in
			switch result {
				case .success(let currentTrip):
					self.currentTrip = currentTrip
				case .failure(let error):
					showError(error: error.localizedDescription + "update trip")
			}
		}
	}

	func endTrip() {
		API.endTrip(scooterID: mapViewModel.selectedScooter!.id) { result in
			switch result {
				case .success: print("")
				case .failure(let error): showError(error: error.localizedDescription)
			}
		}
	}
	
	func lockScooter() {
		API.lockUnlock(path: "lock", scooterID: mapViewModel.selectedScooter!.id) { result in
			switch result {
				case .success: showMessage(message: "Scooter locked")
				case .failure(let error): showError(error: error.localizedDescription)
			}
		}
	}
	
	func unlockScooter() {
		API.lockUnlock(path: "lock", scooterID: mapViewModel.selectedScooter!.id) { result in
			switch result {
				case .success: showMessage(message: "Scooter unlocked")
				case .failure(let error): showError(error: error.localizedDescription)
			}
		}
	}
}
