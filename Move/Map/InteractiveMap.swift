//
//  Interactive.swift
//  Move
//
//  Created by Sergiu Corbu on 4/11/21.
//

import SwiftUI
import MapKit

struct InteractiveMap: View {
	
	@EnvironmentObject var mapViewModel: MapViewModel
	@EnvironmentObject var tripViewModel: TripViewModel
	@State private var region = MKCoordinateRegion.defaultRegion
	@State private var showAlert: Bool = false
	
	let onMenu: () -> Void
	let onScooterSelected: (Scooter) -> Void
	
	var body: some View {
		
		ZStack(alignment: .top) {
			Map(coordinateRegion: $region, interactionModes: .all, showsUserLocation: mapViewModel.locationManager.showLocation, annotationItems: !Session.ongoingTrip ? mapViewModel.allScooters.filter({$0.available == true }) : []) { scooter in
				MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: scooter.location.coordinates[1], longitude: scooter.location.coordinates[0])) {
					Image(scooter.isSelected ? "pin-fill-active-img" : "pin-fill-img")
						.onTapGesture {
							mapViewModel.selectScooter(scooter: scooter)
							if let currentScooter = mapViewModel.selectedScooter {
								onScooterSelected(currentScooter)
							}
					}
				}
			}
			.onAppear {
				//print(Session.tokenKey as Any)
				manageLocation()
			}
			.edgesIgnoringSafeArea(.all)
			SharedElements.MapBarItems(menuAction: { onMenu() }, text: mapViewModel.locationManager.cityName, locationEnabled: mapViewModel.locationManager.showLocation, centerLocation: { centerViewOnUserLocation() } )
		}
		.alert(isPresented: $showAlert) { alertView }
	}
	
	private func manageLocation() {
		if mapViewModel.locationManager.showLocationAlert {
			showAlert = true
		} else {
			centerViewOnUserLocation()
			if mapViewModel.locationManager.showLocation {
				DispatchQueue.main.async { centerViewOnUserLocation() }
			}
		}
	}
	
	private func centerViewOnUserLocation() {
		guard let location = mapViewModel.locationManager.locationManager.location?.coordinate else { return }
		region = MKCoordinateRegion(center: location, latitudinalMeters: 900, longitudinalMeters: 900)
		mapViewModel.userLocation = location
	}
	
	private var alertView: Alert {
		Alert.init(title: Text("Enable location services"),
				   dismissButton: .default(Text("Go to Settings"),
				   action: { UIApplication.shared.open(URL(string: "App-prefs:root=Privacy&path=LOCATION")!)})
		)
	}
}
