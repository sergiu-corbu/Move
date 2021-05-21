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
	
	@EnvironmentObject var mapViewModel: MapViewModel
	
	@Published var tripCount: Int = 0
	@Published var currentTripTime: Int = 0
	@Published var currentTripDistance: Int = 0
	@Published var ongoing: Bool = false
	@Published var currentTripScooter: Scooter?
	@Published var price: Int = 0
	@Published var startStreet: String = ""
	@Published var endStreet: String = ""
	@Published var allTrips: [Trip] = []
	@Published var tripRegion: MKCoordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 46.74834800, longitude: 23.58783800), latitudinalMeters: 1700, longitudinalMeters: 1700)
	// put them inside a class
	@Published var path: [[Double]] = []
	

	func streetsGeocode(_ callback: @escaping () -> Void) {
		let geocoder = CLGeocoder()
		let startCoord: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: path[0][1], longitude: path[0][0])
		let endCoord: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: path[0][1], longitude: path[0][0])
		let startAddress = CLLocation(latitude: startCoord.latitude, longitude: startCoord.longitude)
		//let endAddress = CLLocation(latitude: endCoord.latitude, longitude: endCoord.longitude)
		
		geocoder.reverseGeocodeLocation(startAddress) { (placemarks, error) in
			guard let placemark = placemarks?.first else {
				showError(error: "could not reverse geocode")
				return
			}
			let streetName: String = placemark.thoroughfare ?? ""
			let streetNumber: String = placemark.subThoroughfare ?? ""
			let result = streetName + " " + streetNumber
			self.startStreet = result
			callback()
		}
		
//		geocoder.reverseGeocodeLocation(endAddress) { (placemarks, error) in
//			guard let placemark = placemarks?.first else {
//				showError(error: "could not reverse geocode")
//				return
//			}
//			let streetName: String = placemark.thoroughfare ?? "n/a"
//			let streetNumber: String = placemark.subThoroughfare ?? "n/a"
//			let result = streetName + " " + streetNumber
//			self.endStreet = result
//			callback()
//		}
//
		
		// callback down here
	}
	
	func downloadTrips(pageSize: Int) {
		API.downloadTrips(pageSize: pageSize,  { result in
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
					self.currentTripDistance = currentTrip.distance
					self.currentTripScooter = currentTrip.trip.scooter
					self.currentTripTime = currentTrip.duration
					self.ongoing = currentTrip.trip.ongoing
					self.path = currentTrip.trip.path
					callback?()
				case .failure: break
			}
		}
	}
	
	func updateTripContinuosly(_ callback: (() -> Void)? = nil) {
		updateTrip {
			callback?()
			DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
				print("trip updated..")
				self.updateTripContinuosly()
			}
		}
	}

	func endTrip(_ callback: @escaping () -> Void) {
		unwrapScooter { [self] scooter in
			API.endTrip(scooterID: scooter.id, startStreet: startStreet, endStreet: startStreet) { result in
				switch result {
					case .success(let result):
						self.currentTripTime = result.trip.duration / 100000
						self.currentTripDistance = result.trip.totalDistance
						self.price = result.trip.price
//						self.tripRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: path.first![1], longitude: path.first![0]), span: MKCoordinateSpan(latitudeDelta: 700, longitudeDelta: 700))
//						print(self.tripRegion)
						callback()
					case .failure(let error):
						showError(error: error.localizedDescription)
						callback()
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
	
	func unwrapScooter(_ callback: @escaping (Scooter) -> Void) {
		guard let scooter = self.currentTripScooter else {
			return
		}
		callback(scooter)
	}
}
