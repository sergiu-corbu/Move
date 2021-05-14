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
	//@StateObject var scooterViewModel: ScooterViewModel = ScooterViewModel.shared
	@State private var unlockPressed: Bool = false
	@State private var pinPressed = false
	@State var showUnlock = false
	@State var showTrip = false
	@State var showTripDetails = false
	@State var showSummary = false
	@State var showScooterCard = true
	
	var body: some View {
		ZStack(alignment: .bottom) {
			MapView(mapViewModel: mapViewModel, onMenu: {  handleOnMenu() })
			if let selectedScooter = self.mapViewModel.selectedScooter {
				if showScooterCard {
					ScooterViewItem(scooter: selectedScooter, isUnlocked: $unlockPressed, onTapp: {showScooterCard = false})
				}
				if unlockPressed {
					UnlockScooterMethods(onQR: {}, onPin: { pinPressed = true }, onNFC: {}, scooter: selectedScooter)
				}
				if showTrip {
					StartRide(scooter: selectedScooter, onStartRide: { scooter in
						showTripDetails = true
						unlockPressed = false
						showTrip = false
						Session.ongoingTrip = true
						self.mapViewModel.getAvailableScooters()
					})
				}
				if showTripDetails {
					TripDetailView(scooter: selectedScooter, onEndRide: {
						mapViewModel.selectedScooter = nil
						showTripDetails = false
						showSummary = true
					})
				}
			}
			if pinPressed {
				CodeUnlock(onClose: {pinPressed = false}, onFinished: {
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
				FinishTrip(onFinish: {
					Session.ongoingTrip = false
					showSummary = false
					showScooterCard = true
					mapViewModel.getAvailableScooters()
				})
			}
		}

	}
	
	func handleOnMenu() {
		navigationViewModel.push(MenuView(onBack: { navigationViewModel.pop() },
										  onSeeAll: { navigationViewModel.push(HistoryView(onBack: { navigationViewModel.pop() }))
										  }, onAccount: {
											navigationViewModel.push(AccountView(onBack: { navigationViewModel.pop() }, onLogout: { navigationViewModel.push(ContentView())}, onSave: { navigationViewModel.pop() }))
										}, onChangePassword: { navigationViewModel.push(ChangePasswordView(action: {navigationViewModel.pop()})) }))
	}
}

struct MapView: View {
	@ObservedObject var mapViewModel: MapViewModel
	//@ObservedObject var scooterViewModel: ScooterViewModel
	@State private var region = MKCoordinateRegion.defaultRegion
	
	func centerViewOnUserLocation() {
		guard let location = mapViewModel.locationManager.location?.coordinate else { print("errorr"); return }
		region = MKCoordinateRegion(center: location, latitudinalMeters: 900, longitudinalMeters: 900)
		mapViewModel.location = location
	}
	let onMenu: () -> Void
	
	var body: some View {
		ZStack(alignment: .top) {
			Map(coordinateRegion: $region, interactionModes: .all, showsUserLocation: mapViewModel.locationManager.showLocation, annotationItems: !Session.ongoingTrip ?  mapViewModel.allScooters.filter({$0.available == true }) : []) { scooter in
					MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: scooter.location.coordinates[1], longitude: scooter.location.coordinates[0]))
					{
						Image(scooter.isSelected ? "pin-fill-active-img" : "pin-fill-img").onTapGesture {
							print(scooter.isSelected)
							self.mapViewModel.selectScooter(scooter: scooter) }
					}
			}
			.edgesIgnoringSafeArea(.all)
			.onTapGesture { mapViewModel.selectedScooter = nil }
			.onAppear {
				centerViewOnUserLocation()
				if mapViewModel.locationManager.showLocation {
					DispatchQueue.main.async { centerViewOnUserLocation() }
				}
			}
			SharedElements.MapBarItems(menuAction: { onMenu(); mapViewModel.selectedScooter = nil}, text: mapViewModel.locationManager.cityName, locationEnabled: mapViewModel.locationManager.showLocation, centerLocation: { centerViewOnUserLocation(); mapViewModel.selectedScooter = nil } )
		}
	}
}

extension MKCoordinateRegion {
	static var defaultRegion: MKCoordinateRegion {
		MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 46.753498, longitude: 23.59), latitudinalMeters: 4000, longitudinalMeters: 4000)
	}
}
