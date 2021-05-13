//
//  TripViewModel.swift
//  Move
//
//  Created by Sergiu Corbu on 06.05.2021.
//

import Foundation

class TripViewModel: ObservableObject {
	static var shared: TripViewModel = TripViewModel()
	var allTrips: [Trip] = []
	@Published var tripCount: Int = 0
	
	init() {
		downloadTrips()
	}
	
	func downloadTrips() {
		API.downloadTrips({ result in
			switch result {
				case .success(let trips):
					self.allTrips = trips.trips
					self.tripCount = trips.totalTrips
				case .failure(let error): showError(error: error.localizedDescription)
			}
		})
	}

	func endTrip() {
		API.basicCall(path: "end") { result in
			switch result {
				case .success(let result): showMessage(message: result.message)
				case .failure(let error): showError(error: error.localizedDescription)
			}
		}
	}
	
	func lockScooter() {
		API.basicCall(path: "lock") { result in
			switch result {
				case .success: showMessage(message: "Scooter locked")
				case .failure(let error): showError(error: error.localizedDescription)
			}
		}
	}
	
	func unlockScooter() {
		API.basicCall(path: "unlock") { result in
			switch result {
				case .success: showMessage(message: "Scooter unlocked")
				case .failure(let error): showError(error: error.localizedDescription)
			}
		}
	}
}
