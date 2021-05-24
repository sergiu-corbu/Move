//
//  MapCoordinator.swift
//  Move
//
//  Created by Sergiu Corbu on 17.05.2021.
//

import NavigationStack
import SwiftUI
import CoreLocation

struct MapCoordinator: View {
	
	@ObservedObject var navigationStack: NavigationStack = SceneDelegate.navigationStack
	@StateObject var mapViewModel: MapViewModel = MapViewModel()
	@StateObject var tripViewModel: TripViewModel = TripViewModel()
	@StateObject var stopWatch: StopWatchViewModel = StopWatchViewModel()
	@State var bottomContainer: AnyView

	var body: some View {
		ZStack(alignment: .bottom) {
			InteractiveMap(onMenu: { menuCoordinator() }, scootersInCluster: { selectedScooter in
				selectedScooter.count > 1 ? showScooterRow(scooterList: selectedScooter) : showUnlockMethods()
			})
			bottomContainer
		}
		.environmentObject(tripViewModel)
		.environmentObject(mapViewModel)
		.onAppear {
			checkForOngoingTrip()
		}
	}
	
	func unlckTypeCoordinator(type: UnlockType) {
		switch type {
			case .code: showCode()
			case .qr: showQR()
			case .nfc: showNFC()
		}
	}
	
	func showScooterRow(scooterList: [Scooter]) {
		bottomContainer = AnyView(ScootersRow(scooterList: scooterList, onSelectScooter: { scooter in
			mapViewModel.selectedScooter = scooter
			showUnlockMethods()
		}))
	}
	
	func showUnlockMethods() {
		guard let selectedScooter = mapViewModel.selectedScooter else { return }
		bottomContainer = AnyView(UnlockMethods(scooter: selectedScooter, unlockMethod: { unlockType in
			unlckTypeCoordinator( type: unlockType)
		}, onDragDown: {
			bottomContainer = AnyView(EmptyView())
			mapViewModel.selectedScooter = nil
		}))
	}
	
	func showCode() {
		guard let selectedScooter = mapViewModel.selectedScooter else {
			showError(error: "Scooter not available")
			return
		}
		bottomContainer = AnyView(CodeUnlock(unlockViewModel: UnlockViewModel(scooter: selectedScooter, coordinates: mapViewModel.userCoordinates), onClose: {
			showUnlockMethods()
		}, onFinished: {
			showUnlockSuccess()
		}, unlockMethod: { unlockType in
			unlckTypeCoordinator(type: unlockType)
		}))
	}
	
	func showNFC() {
		bottomContainer = AnyView(NFCUnlock(onClose: { showUnlockMethods()
		}, onFinished: {
			// start ride..
		}, unlockMethod: { unlockType in
			unlckTypeCoordinator(type: unlockType)
		}))
	}
	
	func showQR() {
		bottomContainer = AnyView(QRUnlock(onClose: { showUnlockMethods()}, unlockMethod: { unlockType in
			unlckTypeCoordinator(type: unlockType)
		}))
	}
	
	func showUnlockSuccess() {
		bottomContainer = AnyView(UnlockSuccesful(onFinished: {
			showStartRide()
		}))
	}

	func showStartRide() {
		bottomContainer = AnyView(StartRide(onStartRide: {
			Session.ongoingTrip = true
			tripViewModel.updateTripContinuosly {
				unwrapScooter(scooter: mapViewModel.selectedScooter) { scooter in
					showTripDetail(currentScooter: scooter)
					stopWatch.stopWatch.time = 0
					stopWatch.startTimer()
				}
			}
		}))
	}
	
	func showTripDetail(currentScooter: Scooter) {
		bottomContainer = AnyView(TripDetail(stopWatch: stopWatch, scooter: currentScooter , onEndRide: {
			tripViewModel.streetsGeocode {
				tripViewModel.endTrip {
					showFinishTrip()
				}
			}
		}))
	}
	
	func showFinishTrip() {
		bottomContainer = AnyView(FinishTrip(tripRegion: tripViewModel.trip.tripRegion, onFinish: {
			Session.ongoingTrip = false
			mapViewModel.selectedScooter = nil
			mapViewModel.getAvailableScooters()
			stopWatch.resetTimer()
			bottomContainer = AnyView(EmptyView())
		}))
	}
	
	func checkForOngoingTrip() {
		tripViewModel.updateTrip() {
			if tripViewModel.trip.ongoing {
				unwrapScooter(scooter: tripViewModel.trip.tripScooter) { scooter in
					stopWatch.stopWatch.time = tripViewModel.trip.time / 100000 
					showTripDetail(currentScooter: scooter)
					tripViewModel.updateTripContinuosly()
					stopWatch.startTimer()
				}
			}
		}
	}
		
	func menuCoordinator() {
		navigationStack.push(MenuCoordinator().environmentObject(tripViewModel))
	}
}
