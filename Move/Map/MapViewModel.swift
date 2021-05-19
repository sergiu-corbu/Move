//
//  MapViewModel.swift
//  Move
//
//  Created by Sergiu Corbu on 22.04.2021.
//

import Foundation
import CoreLocation
import MapKit

class MapViewModel: NSObject, CLLocationManagerDelegate, ObservableObject {
	
	static var shared: MapViewModel = MapViewModel()
	
	@Published var allScooters: [Scooter] = []
	@Published var scooterLocation: String = ""
	@Published var selectedScooter: Scooter?
	@Published var locationManager = LocationManager()
	
	var userLocation: CLLocationCoordinate2D? {
		didSet {
			if oldValue == nil { reloadData() }
		}
	}
	
	func selectScooter(scooter: Scooter) {
		locationGeocode(location: scooter.coordinates) { address in
			var scooter = scooter
			scooter.addressName = address
			self.selectedScooter = scooter
		}
	}
	
	private func reloadData() {
		getAvailableScooters()
		DispatchQueue.main.asyncAfter(deadline: .now() + 30, execute: {
			self.reloadData()
		})
	}
	
	func getAvailableScooters() {
		guard let location = self.userLocation else { return }
		API.getScooters(coordinates: location) { result in
			switch result {
				case .success(let scooters):
					self.allScooters = scooters
				case .failure(let error):
					showError(error: error.localizedDescription)
			}
		}
	}
	
    func locationGeocode(location coordinates: CLLocationCoordinate2D, _ completion: @escaping (String) -> Void) {
        let geocoder = CLGeocoder()
        let scooterLocation = CLLocation(latitude: coordinates.latitude, longitude: coordinates.longitude)
        geocoder.reverseGeocodeLocation(scooterLocation) { (placemarks, error) in //[weak self] (placemarks, error) in
            if let error = error {
				showError(error: error.localizedDescription)
				return
			}
            guard let placemark = placemarks?.first else { return }
			let streetName: String = placemark.thoroughfare ?? "n/a"
			let streetNumber: String = placemark.subThoroughfare ?? "n/a"
			let result = streetName + " " + streetNumber
            completion(result)
        }
    }
}
