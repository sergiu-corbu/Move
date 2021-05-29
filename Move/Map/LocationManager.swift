//
//  LocationManager.swift
//  Move
//
//  Created by Sergiu Corbu on 14.05.2021.
//

import Foundation
import CoreLocation
import SwiftUI

class LocationManager: NSObject, ObservableObject {
	
	@Published var locationManager = CLLocationManager()
	@Published var location: CLLocation?
	@Published var cityName: String = "Allow location"
	@Published var showUserLocation: Bool = false
	@Published var locationDisabled: Bool = false
	
	private let geocoder = CLGeocoder()
	
	override init() {
		super.init()
		checkLocationServices()
	}
	
	func checkLocationServices() {
		if CLLocationManager.locationServicesEnabled() {
			locationManager.delegate = self
			locationManager.desiredAccuracy = kCLLocationAccuracyBest
			checkLocationAuthorization()
		} else {
			locationDisabled = true
		}
	}
	
	func checkLocationAuthorization() {
		switch locationManager.authorizationStatus {
			case .authorizedWhenInUse, .authorizedAlways:
				showUserLocation = true
				locationManager.startUpdatingLocation()
				geoCode()
			case .notDetermined:
				locationManager.requestWhenInUseAuthorization()
			case .denied, .restricted:
				break
			@unknown default:
				assert(false, "handle new added case")
				break
		}
	}
	
	func geoCode() {
		let geocoder = CLGeocoder()
		guard let location = locationManager.location else {
			showError(error: "Couldn't retrieve your location")
			return
		}
		geocoder.reverseGeocodeLocation(location) { [weak self] (placemarks, error) in
			guard let self = self else {
				showError(error: "Unknown place")
				return
			}
			guard let placemark = placemarks?.first else { return }
			self.cityName = placemark.locality ?? "Not found"
		}
	}
}

extension LocationManager: CLLocationManagerDelegate {

	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		guard let location = locations.last else { return }
		DispatchQueue.main.async {
			self.location = location
			self.locationManager.startUpdatingLocation()
		}
	}
	
	func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
		DispatchQueue.main.async {
			if status == .authorizedAlways || status == .authorizedWhenInUse {
				self.checkLocationServices()
			}
		}
	}
}
