//
//  MapView.swift
//  Move
//
//  Created by Sergiu Corbu on 4/11/21.
//

import MapKit
import SwiftUI

struct MapView: View {
	@ObservedObject var mapViewModel: MapViewModel
	@State private var region = MKCoordinateRegion.defaultRegion
	@State private var showAlert: Bool = false
	
	let onMenu: () -> Void
	
	var body: some View {
		ZStack(alignment: .top) {
			Map(coordinateRegion: $region, interactionModes: .all, showsUserLocation: mapViewModel.locationManager.showLocation, annotationItems: !Session.ongoingTrip ?  mapViewModel.allScooters.filter({$0.available == true }) : []) { scooter in
				MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: scooter.location.coordinates[1], longitude: scooter.location.coordinates[0]))
				{
					Image(scooter.isSelected ? "pin-fill-active-img" : "pin-fill-img").onTapGesture {
						self.mapViewModel.selectScooter(scooter: scooter) }
				}
			}
			.edgesIgnoringSafeArea(.all)
			.onTapGesture { mapViewModel.selectedScooter = nil }
			.onAppear {
				if mapViewModel.locationManager.showLocationAlert {
					showAlert = true
				}
				centerViewOnUserLocation()
				if mapViewModel.locationManager.showLocation {
					DispatchQueue.main.async { centerViewOnUserLocation() }
				}
			}
			SharedElements.MapBarItems(menuAction: { onMenu(); mapViewModel.selectedScooter = nil}, text: mapViewModel.locationManager.cityName, locationEnabled: mapViewModel.locationManager.showLocation, centerLocation: { centerViewOnUserLocation(); mapViewModel.selectedScooter = nil } )
		}
		.alert(isPresented: $showAlert) {
			Alert.init(title: Text("Enable location services"), dismissButton: .default(Text("Go to Settings"), action: {
							UIApplication.shared.open(URL(string: "App-prefs:root=Privacy&path=LOCATION")!)})
			)
		}
	}
	
	private func centerViewOnUserLocation() {
		guard let location = mapViewModel.locationManager.locationManager.location?.coordinate else { return }
		region = MKCoordinateRegion(center: location, latitudinalMeters: 900, longitudinalMeters: 900)
		mapViewModel.userLocation = location
	}
}
