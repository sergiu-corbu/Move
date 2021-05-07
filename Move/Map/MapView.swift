//
//  MapView.swift
//  Move
//
//  Created by Sergiu Corbu on 4/11/21.
//

import MapKit
import SwiftUI
import NavigationStack

enum UnlockType {
	case code
	case qr
	case nfc
}

struct MapCoordinator: View {
	var navigationViewModel = NavigationStack()
	@StateObject var mapViewModel: MapViewModel = MapViewModel()
	@StateObject var scooterViewModel: ScooterViewModel = ScooterViewModel()
	@State private var unlockPressed: Bool = false
	
	let onMenu: () -> Void
	let onUnlockScooter: (UnlockType, Scooter) -> Void
	
	var body: some View {
		NavigationStackView(navigationStack: navigationViewModel) {
			ZStack(alignment: .top) {
				MapView(mapViewModel: mapViewModel, scooterViewModel: scooterViewModel, onMenu: {onMenu()})
				if let selectedScooter = self.mapViewModel.selectedScooter {
					VStack {
						Spacer()
						ZStack(alignment: .bottom) {
							ScooterViewItem(scooter: selectedScooter, isUnlocked: $unlockPressed)
								.padding([.leading, .trailing], 15)
							if unlockPressed {
								UnlockScooterCard(onQR: {}, onPin: {onUnlockScooter(UnlockType.code, selectedScooter); unlockPressed = false}, onNFC: {}, scooter: selectedScooter)
							}
						}
					}
					
				}
				
			}
		}
	}
	
	struct MapView: View {
		@ObservedObject var mapViewModel: MapViewModel
		@ObservedObject var scooterViewModel: ScooterViewModel
		@State private var region = MKCoordinateRegion.defaultRegion
		
		public func centerViewOnUserLocation() {
			guard let location = mapViewModel.locationManager.location?.coordinate else { print("errorr"); return }
			region = MKCoordinateRegion(center: location, latitudinalMeters: 900, longitudinalMeters: 900)
			scooterViewModel.location = location
		}
		let onMenu: () -> Void
		
		var body: some View {
			ZStack(alignment: .top) {
				Map(coordinateRegion: $region, interactionModes: .all, showsUserLocation: mapViewModel.showLocation, annotationItems: scooterViewModel.allScooters) { scooter in
					MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: scooter.location.coordinates[1], longitude: scooter.location.coordinates[0]))
					{
						Image("pin-fill-img")
							.onTapGesture { self.mapViewModel.selectScooter(scooter: scooter) }
					}
				}
				.edgesIgnoringSafeArea(.all)
				.onTapGesture { mapViewModel.selectedScooter = nil }
				.onAppear {
					if mapViewModel.showLocation {
						centerViewOnUserLocation()
						DispatchQueue.main.async { centerViewOnUserLocation() }
					}
				}
			}
			SharedElements.MapBarItems(menuAction: {onMenu()}, text: mapViewModel.cityName, locationEnabled: mapViewModel.showLocation, centerLocation: { centerViewOnUserLocation(); mapViewModel.selectedScooter = nil } )
		}
	}
}

extension MKCoordinateRegion {
	static var defaultRegion: MKCoordinateRegion {
		MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 46.753498, longitude: 23.59), latitudinalMeters: 4000, longitudinalMeters: 4000)
	}
}
