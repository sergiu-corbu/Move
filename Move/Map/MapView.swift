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
	var navigationViewModel: NavigationStack
	@StateObject var mapViewModel: MapViewModel = MapViewModel.shared
	@StateObject var scooterViewModel: ScooterViewModel = ScooterViewModel.shared
	@State private var unlockPressed: Bool = false
	
	let onUnlockScooter: (UnlockType, Scooter) -> Void
	
	var body: some View {
		NavigationStackView(navigationStack: navigationViewModel) {
			ZStack(alignment: .top) {
				MapView(onMenu: {  handleOnMenu() })
				if let selectedScooter = self.mapViewModel.selectedScooter {
					VStack {
						Spacer()
						ZStack(alignment: .bottom) {
							ScooterViewItem(scooter: selectedScooter, isUnlocked: $unlockPressed)
								.padding(.horizontal, 15)
							if unlockPressed {
								UnlockScooterCard(onQR: {}, onPin: {onUnlockScooter(UnlockType.code, selectedScooter); unlockPressed = false}, onNFC: {}, scooter: selectedScooter)
							}
						}
					}
				}
				
			}
		}
	}
	
	func handleOnMenu() {
		navigationViewModel.push(MenuView(onBack: { navigationViewModel.pop() },
										  onSeeAll: {
											navigationViewModel.push(HistoryView(onBack: { navigationViewModel.pop() }))
										  }, onAccount: {
											navigationViewModel.push(AccountView(onBack: { navigationViewModel.pop() }, onLogout: { navigationViewModel.push(Onboarding(onFinished: { /*handleRegister() */}))}, onSave: { navigationViewModel.pop() }))
										}, onChangePassword: {
											navigationViewModel.push(ChangePasswordView(action: {navigationViewModel.pop()}))
										}))
	}
}

struct MapView: View {
	@ObservedObject var mapViewModel: MapViewModel = MapViewModel.shared
	@ObservedObject var scooterViewModel: ScooterViewModel = ScooterViewModel.shared
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
		SharedElements.MapBarItems(menuAction: { onMenu(); mapViewModel.selectedScooter = nil}, text: mapViewModel.cityName, locationEnabled: mapViewModel.showLocation, centerLocation: { centerViewOnUserLocation(); mapViewModel.selectedScooter = nil } )
	}
}

extension MKCoordinateRegion {
	static var defaultRegion: MKCoordinateRegion {
		MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 46.753498, longitude: 23.59), latitudinalMeters: 4000, longitudinalMeters: 4000)
	}
}
