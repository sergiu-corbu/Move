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
	
	@ObservedObject var navigationStack: NavigationStack
	@StateObject var mapViewModel: MapViewModel = MapViewModel()
	@StateObject var tripViewModel: TripViewModel = TripViewModel()
	@StateObject var stopWatch: StopWatchViewModel = StopWatchViewModel()
	@State var bottomContainer: AnyView

	var body: some View {
		ZStack(alignment: .bottom) {
			InteractiveMap(mapViewModel: mapViewModel, locationManager: mapViewModel.locationManager, onMenu: { menuCoordinator() },
						   scootersInCluster: { selectedScooter in
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
		}, unlockMethod: { unlockType in
			unlckTypeCoordinator(type: unlockType)
		}))
	}
	
	func showQR() {
		bottomContainer = AnyView(QRUnlock(onClose: { showUnlockMethods()}, onFinish: {
			showUnlockSuccess()
		}, unlockMethod: { unlockType in
			unlckTypeCoordinator(type: unlockType)
		}))
	}
	
	func showUnlockSuccess() {
		bottomContainer = AnyView(UnlockSuccesful(onFinished: {
			Session.ongoingTrip = true
			stopWatch.stopWatch.time = 0
			stopWatch.startTimer()
			unwrapScooter(scooter: mapViewModel.selectedScooter) { scooter in
				API.getCurrentScooter(scooterId: scooter.id) { result in
					switch result {
						case .success(let scooter):
							self.tripViewModel.updateTrip(ongoingTrip: { isOngoing in
								tripViewModel.updateTripContinuosly {
									showTripDetail(currentScooter: scooter.scooter)
								}
							})
						case .failure(let error):
							showError(error: error.localizedDescription)
					}
				}
			}
		}))
	}
	
	func showTripDetail(currentScooter: Scooter) {
		bottomContainer = AnyView(TripDetails(stopWatch: stopWatch, scooter: currentScooter, onEndRide: {
			tripViewModel.endTrip(coordinates: mapViewModel.userCoordinates) {
				showFinishTrip()
			}
		}))
	}
	
	func showFinishTrip() {
		bottomContainer = AnyView(FinishTrip(onFinish: {
			Session.ongoingTrip = false
			mapViewModel.selectedScooter = nil
			mapViewModel.getAvailableScooters()
			stopWatch.resetTimer()
			bottomContainer = AnyView(EmptyView())
		}))
	}

	func menuCoordinator() {
		navigationStack.push(MenuCoordinator(navigationStack: navigationStack).environmentObject(tripViewModel))
	}
	
	func checkForOngoingTrip() {
		tripViewModel.updateTrip { isOngoing in
			if isOngoing {
				stopWatch.stopWatch.time = tripViewModel.seconds
				stopWatch.startTimer()
				let scooterId = tripViewModel.ongoingTrip.scooterId
				API.getCurrentScooter(scooterId: scooterId) { result in
					switch result {
						case .success(let scooter):
							tripViewModel.updateTripContinuosly {
								showTripDetail(currentScooter: scooter.scooter)
							}
						case .failure: break
					}
				}
			}
		}
	}
}
