//
//  MapViewModel.swift
//  Move
//
//  Created by Sergiu Corbu on 22.04.2021.
//

import SwiftUI
import CoreLocation
import NavigationStack

class MapViewModel: NSObject, CLLocationManagerDelegate, ObservableObject {
	
	@ObservedObject var navigationStack: NavigationStack = SceneDelegate.navigationStack
	@Published var locationManager = LocationManager()
	@Published var clusters: [Cluster] = []
	@Published var selectedScooter: Scooter?
	
	var userLocation: CLLocation {
		guard let location = locationManager.locationManager.location else {
			showError(error: "Cannot get user location")
			return CLLocation(latitude: 0, longitude: 0)
		}
		return CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
	}

	var distanceToScooter: Double {
		if let scooter = selectedScooter {
			let scooterLocation = CLLocation(latitude: scooter.coordinates.latitude, longitude: scooter.coordinates.longitude)
			return userLocation.distance(from: scooterLocation)
		}
		showError(error: "Cannot get scooter location")
		return 10000
	}
	
	var userCoordinates: [Double] {
		return [userLocation.coordinate.latitude, userLocation.coordinate.longitude]
	}
	
	func makeClusters(scooterList: [Scooter]) {
		var scooters: [Scooter] = scooterList
		var clusters: [Cluster] = []
		for i in 0..<scooters.count {
			var cluster: Cluster = Cluster()
			for j in i + 1..<scooters.count {
				if scooters[i].scooterLocation.distance(from: scooters[j].scooterLocation) < 40 && !scooters[j].isInCluster { // add battery > 20
					if !scooters[i].isInCluster {
						cluster.scooters.append(scooters[i])
						cluster.scooters.append(scooters[j])
					} else {
						cluster.scooters.append(scooters[j])
					}
					scooters[i].isInCluster = true
					scooters[j].isInCluster = true
				}
			}
			if !scooters[i].isInCluster {
				cluster.scooters.append(scooters[i])
			}
			clusters.append(cluster)
		}
		self.clusters = clusters.filter( { !$0.scooters.isEmpty })
	}
	
	func selectScooter(scooter: Scooter) {
		locationGeocode(location: scooter.coordinates) { address in
			var scooter = scooter
			scooter.addressName = address
			self.selectedScooter = scooter
		}
	}
	
	func reloadData() {
		getAvailableScooters()
		DispatchQueue.main.asyncAfter(deadline: .now() + 60, execute: {
			self.reloadData()
		})
	}
	
	func getAvailableScooters() {
		API.getScooters(coordinates: userCoordinates) { result in
			switch result {
				case .success(let scooters):
					self.makeClusters(scooterList: scooters)
				case .failure(let error):
					handleFailure(error: error, navigationStack: self.navigationStack)
			}
		}
	}
	
	func pingScooter(scooter: Scooter) {
		API.pingScooter(scooterKey: scooter.deviceKey, location: [userLocation.coordinate.latitude, userLocation.coordinate.longitude]) { _ in}
	}
}
