//
//  LocationManager.swift
//  Move
//
//  Created by Sergiu Corbu on 14.05.2021.
//

import Foundation
import CoreLocation
import MapKit

class LocationManager: NSObject, ObservableObject {
	@Published var showLocation: Bool = false
	@Published var locationManager = CLLocationManager()
	private let geocoder = CLGeocoder()
	@Published var location: CLLocation?
	@Published var cityName: String = "Allow location"
	@Published var showLocationAlert: Bool = false
	
	override init() {
		super.init()
		checkLocationServices()
	}
	
	func checkLocationServices() {
		if CLLocationManager.locationServicesEnabled() {
			setupLocationManager()
			checkLocationAuthorization()
		} else {
			showLocationAlert = true
		}
	}
	
	func setupLocationManager() {
		locationManager.delegate = self
		locationManager.desiredAccuracy = kCLLocationAccuracyBest
	}
	
	func checkLocationAuthorization() {
		switch locationManager.authorizationStatus {
			case .authorizedWhenInUse, .authorizedAlways: startTrackingUserLocation()
			case .notDetermined: locationManager.requestWhenInUseAuthorization()
			case .denied, .restricted: break
			@unknown default:
				assert(false, "handle new added case")
				break
		}
	}
	
	func startTrackingUserLocation() {
		showLocation = true
		locationManager.startUpdatingLocation()
		geoCode()
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
			if let error = error { print(error); return }
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
			//self.locationManager.startUpdatingLocation()
			self.geoCode()
		}
	}
}
