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
				case .success(let currentTrip): print("checking for ungoing trip")
					self.currentTrip = currentTrip
					callback?()
				case .failure: print("")
			}
		}
	}

	func endTrip() {
		guard let scooter = self.currentTrip?.trip.scooter else {
			return
		}
		API.endTrip(scooterID: scooter.id) { result in
			switch result {
				case .success: print("")
				case .failure(let error): showError(error: error.localizedDescription)
			}
		}
	}
	
	func lockScooter() {
		guard let scooter = self.currentTrip?.trip.scooter else {
			return
		}
		API.lockUnlock(path: "lock", scooterID: scooter.id) { result in
			switch result {
				case .success: showMessage(message: "Scooter locked")
				case .failure(let error): showError(error: error.localizedDescription)
			}
		}
	}
	
	func unlockScooter() {
		guard let scooter = self.currentTrip?.trip.scooter else {
			return
		}
		API.lockUnlock(path: "lock", scooterID: scooter.id) { result in
			switch result {
				case .success: showMessage(message: "Scooter unlocked")
				case .failure(let error): showError(error: error.localizedDescription)
			}
		}
	}
}
