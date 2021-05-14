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
	
	override init() {
		super.init()
		checkLocationServices()
	}
	
	func checkLocationServices() {
		if CLLocationManager.locationServicesEnabled() {
			setupLocationManager()
			checkLocationAuthorization()
		} else {
			print("go to settings to activate global location")
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
		guard let location = locationManager.location else { print("error while unwrapping"); return }
		geocoder.reverseGeocodeLocation(location) { [weak self] (placemarks, error) in
			guard let self = self else { return }
			if let error = error { print(error); return }
			guard let placemark = placemarks?.first else { return }
			self.cityName = placemark.locality ?? "Not defined"
		}
	}
}

extension LocationManager: CLLocationManagerDelegate {
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		guard let location = locations.last else { return }
		DispatchQueue.main.async {
			self.location = location
			//self.locationManager.startUpdatingLocation()
			print("lat: \(location.coordinate.latitude), long: \(location.coordinate.longitude)")
			self.geoCode()
		}
	}
}
