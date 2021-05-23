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
	let scootersInCluster: ([Scooter]) -> Void
	
	var body: some View {
		ZStack(alignment: .top) {
			Map(coordinateRegion: $region, interactionModes: .all, showsUserLocation: mapViewModel.locationManager.showUserLocation, annotationItems: !Session.ongoingTrip ? mapViewModel.clusters : []) { cluster in
				MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: cluster.latitude, longitude: cluster.longitude)) {
					if cluster.scooters.count > 1 {
						SharedElements.ClusterPin(number: cluster.scooters.count, onTapCluster: {
							scootersInCluster(cluster.scooters)
						})
					} else {
						SharedElements.singleScooter
							.onTapGesture {
								mapViewModel.selectScooter(scooter: cluster.scooters[0])
								if let currentScooter = mapViewModel.selectedScooter {
									scootersInCluster([currentScooter])
								}
							}
					}
				}
			}
			.edgesIgnoringSafeArea(.all)
			.onAppear {
				if !Session.ongoingTrip {
					mapViewModel.reloadData()
				}
				manageLocation()
			}
			SharedElements.MapBarItems(menuAction: { onMenu() }, text: mapViewModel.locationManager.cityName, locationEnabled: mapViewModel.locationManager.showUserLocation, centerLocation: { centerViewOnUserLocation() } )
		}
		.alert(isPresented: $showAlert) {
			Alert.init(title: Text("Enable location services"),
					   dismissButton: .default(Text("Go to Settings"),
											   action: { UIApplication.shared.open(URL(string: "App-prefs:root=Privacy&path=LOCATION")!)})
			)
		}
	}
	
	private func manageLocation() {
		if mapViewModel.locationManager.locationDisabled {
			showAlert = true
		} else {
			if mapViewModel.locationManager.showUserLocation {
				DispatchQueue.main.async { centerViewOnUserLocation() }
			}
		}
	}
	
	private func centerViewOnUserLocation() {
		guard let location = mapViewModel.locationManager.locationManager.location else { return }
		region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 900, longitudinalMeters: 900)
	}
}
