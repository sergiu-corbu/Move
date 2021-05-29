//
//  TripViewModel.swift
//  Move
//
//  Created by Sergiu Corbu on 06.05.2021.
//

import Foundation
import SwiftUI
import MapKit
import CoreLocation

class TripViewModel: ObservableObject {

	@Published var tripCount: Int = 0
	@Published var ongoingTrip: OngoingTrip.CurrentTripDecoding = OngoingTrip.CurrentTripDecoding()
	@Published var endTrip: EndTrip.EndTripDecoding = EndTrip.EndTripDecoding()
	@Published var tripLocations: [CLLocationCoordinate2D] = []
	@Published var allTrips: [TripsHistory.Booking] = []
	@Published var seconds: Int = 0
	@Published var centerCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2D()
	var endStreet: String = ""

	func downloadTrips() {
		API.downloadTripHistory(pageSize: 10, { result in
			switch result {
				case .success(let trips):
					self.allTrips = trips.trips
					self.tripCount = trips.trips.count
				case .failure(let error):
					showError(error: error.localizedDescription)
			}
		})
	}
	
	func updateTrip(ongoingTrip: ((Bool) -> Void)? = nil) {
		API.updateTrip { result in
			switch result {
				case .success(let currentTrip):
					self.ongoingTrip = currentTrip.ongoingTrip
					self.seconds = self.getSeconds(startDate: currentTrip.ongoingTrip.startDate)
					ongoingTrip?(true)
				case .failure: print("")
			}
		}
	}
	
	func updateTripContinuosly(_ callback: (() -> Void)? = nil) {
		updateTrip { _ in
			callback?()
			DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
				self.updateTripContinuosly()
			}
		}
	}

	func endTrip(coordinates: [Double], _ callback: @escaping () -> Void) {
		convertStreet(coordinates: coordinates) {
			API.endTrip(scooterID: self.ongoingTrip.scooterId, coordinates: coordinates, endStreet: self.endStreet) { [self] result in
				switch result {
					case .success(let result):
						Session.ongoingTrip = false
						self.endTrip = result.endTrip
						for path in result.endTrip.path {
							let location = CLLocationCoordinate2D(latitude: path[1], longitude: path[0])
							self.tripLocations.append(location)
						}
						self.centerCoordinate = CLLocationCoordinate2D(latitude: endTrip.path.first![1], longitude: endTrip.path.first![0])
						callback()
					case .failure(let error):
						showError(error: error.localizedDescription)
						callback()
				}
			}
		}
	}

	func lockScooter() {
		API.lockUnlock(bookingId: ongoingTrip.tripId) { result in
			switch result {
				case .success:
					showMessage(message: "Scooter locked")
				case .failure(let error):
					showError(error: error.localizedDescription)
			}
		}
	}

	func unlockScooter() {
		API.lockUnlock(bookingId: ongoingTrip.tripId) { result in
			switch result {
				case .success:
					showMessage(message: "Scooter unlocked")
				case .failure(let error):
					showError(error: error.localizedDescription)
			}
		}
	}
	
	func getSeconds(startDate: String) -> Int {
		let formatter = DateFormatter()
		formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
		formatter.timeZone = TimeZone(abbreviation: "EEST")
		
		let startDate: Date = formatter.date(from: startDate)!
		let currentDate = Date()
		let startDateInterval = startDate.timeIntervalSince1970
		let currentDateInterval = currentDate.timeIntervalSince1970
		
		return Int(currentDateInterval - startDateInterval)
	}
	
	func convertStreet(coordinates: [Double], _ callback: @escaping () -> Void) {
		streetGeocode(coordinates: coordinates, { address in
			var street = self.endStreet
			street = address
			self.endStreet = street
			callback()
		})
	}
}
