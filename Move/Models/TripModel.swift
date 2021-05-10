//
//  TripModel.swift
//  Move
//
//  Created by Sergiu Corbu on 05.05.2021.
//

import Foundation
import CoreLocation

struct Trip: Codable {//, Hashable {
//	static func == (lhs: Trip, rhs: Trip) -> Bool {
//		return lhs.duration == rhs.duration && lhs.distance == rhs.distance
//	}
//	func hash(into hasher: inout Hasher) {
//		hasher.combine(duration)
//		hasher.combine(distance)
//	}
	let startStreet: [Double]
	let endStreet: [Double]
	let duration: Int
	let distance: Float
	
	var startStreetCoord: CLLocationCoordinate2D {
		return CLLocationCoordinate2D(latitude: startStreet[1], longitude: startStreet[0])
	}
	var endStreetCoord: CLLocationCoordinate2D {
		return CLLocationCoordinate2D(latitude: endStreet[1], longitude: endStreet[0])
	}
	
	var startLocation: String = ""
	var endLocation: String = ""
	
	enum CodingKeys: String, CodingKey {
		case startStreet = "startStreet"
		case endStreet = "endStreet"
		case duration = "duration"
		case distance = "totalDistance"
	}
	
	func computeAddress(_ completion: @escaping (Trip) -> Void) {
		var trip = self
		if trip.startLocation != "" && trip.endLocation != "" {
			completion(trip)
			return
		}
		locationGeocode(location: startStreetCoord) { result in
			trip.startLocation = result
			if trip.startLocation != "" && trip.endLocation != "" {
				completion(trip)
			}
		}
		locationGeocode(location: endStreetCoord) { result in
			trip.endLocation = result
			if trip.startLocation != "" && trip.endLocation != "" {
				completion(trip)
			}
		}
	}
	
	func locationGeocode(location coordinates: CLLocationCoordinate2D, completion: @escaping (String) -> Void) {
		let geocoder = CLGeocoder()
		let address = CLLocation(latitude: coordinates.latitude, longitude: coordinates.longitude)
		var result: String = ""
		geocoder.reverseGeocodeLocation(address) { (placemarks, error) in
			guard let placemark = placemarks?.first else { return }
			result = placemark.thoroughfare! + " " + placemark.subThoroughfare!
			completion(result)
		}
	}
}
