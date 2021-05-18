//
//  TripViewModel.swift
//  Move
//
//  Created by Sergiu Corbu on 06.05.2021.
//

import Foundation
import SwiftUI

class TripViewModel: ObservableObject {
	
	static var shared: TripViewModel = TripViewModel()
	
	@Published var currentTrip: CurrentTripResult?
	@Published var tripCount: Int = 0
	
	var allTrips: [Trip] = []
	
	init() {
		downloadTrips()
	}
	
	func unwrapScooter(_ callback: @escaping (Scooter) -> Void) {
		guard let scooter = self.currentTrip?.trip.scooter else {
			return
		}
		callback(scooter)
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
	
	func updateTrip(_ callback: (() -> Void)? = nil) {
		API.updateTrip { result in
			switch result {
				case .success(let currentTrip):
					self.currentTrip = currentTrip
					callback?()
				case .failure: break
			}
		}
	}

	func endTrip() {
		unwrapScooter { scooter in
			API.endTrip(scooterID: scooter.id) { result in
				switch result {
					case .success: print("")
					case .failure(let error):
						showError(error: error.localizedDescription)
				}
			}
		}
	}
	
	func lockScooter() {
		unwrapScooter { scooter in
			API.lockUnlock(path: "lock", scooterID: scooter.id) { result in
				switch result {
					case .success:
						showMessage(message: "Scooter locked")
					case .failure(let error):
						showError(error: error.localizedDescription)
				}
			}
		}
	}
	
	func unlockScooter() {
		unwrapScooter { scooter in
			API.lockUnlock(path: "lock", scooterID: scooter.id) { result in
				switch result {
					case .success:
						showMessage(message: "Scooter unlocked")
					case .failure(let error):
						showError(error: error.localizedDescription)
				}
			}
		}
	}
}
