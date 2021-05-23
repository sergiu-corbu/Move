//
//  MapViewModel.swift
//  Move
//
//  Created by Sergiu Corbu on 22.04.2021.
//

import Foundation
import CoreLocation
import MapKit
import SwiftUI
import NavigationStack

class MapViewModel: NSObject, CLLocationManagerDelegate, ObservableObject {
	
	@ObservedObject var navigationStack: NavigationStack = SceneDelegate.navigationStack
	@Published var allScooters: [Scooter] = []
	@Published var scooterLocation: String = ""
	@Published var selectedScooter: Scooter?
	@Published var locationManager = LocationManager()
	@Published var clusters: [Cluster] = []
	
	func makeClusters() {
		for i in 0..<allScooters.count {
			var currentCluster: Cluster = Cluster()
			var currentScooter: Scooter = allScooters[i]
			for j in i + 1..<allScooters.count {
				if currentScooter.scooterLocation.distance(from: allScooters[j].scooterLocation) < 40 && !allScooters[j].isInCluster {
					if !currentScooter.isInCluster {
						currentCluster.scooters.append(currentScooter)
						currentCluster.scooters.append(allScooters[j])
					} else {
						currentCluster.scooters.append(allScooters[j])
					}
					currentScooter.isInCluster = true
					allScooters[j].isInCluster = true
				}
			}
			if !currentScooter.isInCluster {
				currentCluster.scooters.append(currentScooter)
			}
			if !currentCluster.scooters.isEmpty {
				clusters.append(currentCluster)
			}
		}
	}
	
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
					self.makeClusters()
				case .failure(let error):
					if error.localizedDescription == "You are not authorized to access this resource." {
						self.navigationStack.push(AuthCoordinator())
						showError(error: "User suspended")
					} else {
						showError(error: error.localizedDescription)
					}
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
