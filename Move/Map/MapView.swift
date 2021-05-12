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
	@ObservedObject var navigationViewModel: NavigationStack
	@StateObject var mapViewModel: MapViewModel = MapViewModel.shared
	@StateObject var scooterViewModel: ScooterViewModel = ScooterViewModel.shared
	@State private var unlockPressed: Bool = false
	@State private var pinPressed = false
	@State var showUnlock = false
	@State var showTrip = false
	@State var showTripDetails = false
	@State var showSummary = false
	@State var showScooterCard = true
	
	var body: some View {
		ZStack(alignment: .top) {
			MapView(mapViewModel: mapViewModel, scooterViewModel: scooterViewModel, onMenu: {  handleOnMenu() })
			if let selectedScooter = self.mapViewModel.selectedScooter {
				//Spacer()
				//ZStack(alignment: .bottom) {
				VStack {
					Spacer()
					if showScooterCard {
						ScooterViewItem(scooter: selectedScooter, isUnlocked: $unlockPressed, onTapp: {showScooterCard = false})
					}
					if unlockPressed {
						UnlockScooterCard(onQR: {}, onPin: { pinPressed = true }, onNFC: {}, scooter: selectedScooter)
					}
					if showTrip {
						StartRide(scooter: selectedScooter, onStartRide: { scooter in
							showTripDetails = true
							unlockPressed = false
							showTrip = false
						})
					}
					if showTripDetails {
						TripDetailView(tapped: false, scooter: selectedScooter, onEndRide: {
							mapViewModel.selectedScooter = nil
							showTripDetails = false
							showSummary = true
						})
					}
				}
			}
			
			if pinPressed {
				SNUnlock(onClose: {pinPressed = false}, onFinished: {
					showUnlock = true
					pinPressed = false
				})
			}
			if showUnlock {
				UnlockSuccesful(onFinished: {
					showUnlock = false
					showTrip = true
					unlockPressed = false
				})
			}
			if showSummary {
				TripSummary(onFinish: {
					showSummary = false
				})
			}
		}
	}
	
	func handleOnMenu() {
		navigationViewModel.push(MenuView(onBack: { navigationViewModel.pop() },
										  onSeeAll: { navigationViewModel.push(HistoryView(onBack: { navigationViewModel.pop() }))
										  }, onAccount: {
											navigationViewModel.push(AccountView(onBack: { navigationViewModel.pop() }, onLogout: { navigationViewModel.push(Onboarding(onFinished: { }))}, onSave: { navigationViewModel.pop() }))
										}, onChangePassword: { navigationViewModel.push(ChangePasswordView(action: {navigationViewModel.pop()})) }))
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
		SharedElements.MapBarItems(menuAction: { onMenu(); mapViewModel.selectedScooter = nil}, text: mapViewModel.cityName, locationEnabled: mapViewModel.showLocation, centerLocation: { centerViewOnUserLocation(); mapViewModel.selectedScooter = nil } )
	}
}

extension MKCoordinateRegion {
	static var defaultRegion: MKCoordinateRegion {
		MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 46.753498, longitude: 23.59), latitudinalMeters: 4000, longitudinalMeters: 4000)
	}
}
