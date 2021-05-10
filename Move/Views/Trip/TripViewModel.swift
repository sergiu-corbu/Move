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

//	func endTrip() {
//		API.endTrip { result in
//			switch result {
//				case .success(let result): print(result.message)
//				case .failure(let error): showError(error: error.localizedDescription)
//			}
//		}
//	}
	
	func lockScooter() {
		API.lockScooter{ result in
			switch result {
				case .success(let result): print(result.message)
				case .failure(let error): showError(error: error.localizedDescription)
			}
		}
	}
	
	func unlockScooter() {
		API.unlockScooter{ result in
			switch result {
				case .success(let result): print(result.message)
				case .failure(let error): showError(error: error.localizedDescription)
			}
		}
	}
}
