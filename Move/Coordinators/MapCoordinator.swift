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
			InteractiveMap(onMenu: { menuCoordinator() }, onScooterSelected: {  selectedScooter in
				selectedScooter.count > 1 ? showScooterRow(scooterList: selectedScooter) : showUnlockMethods()
			})
			bottomContainer
		}
		.environmentObject(tripViewModel)
		.environmentObject(mapViewModel)
		.onAppear {
			tripViewModel.updateTrip() {
				if tripViewModel.ongoing {
					unwrapScooter { scooter in
						stopWatch.stopWatch.time = tripViewModel.currentTripTime / 100000
						showTripDetail(currentScooter: scooter)
						tripViewModel.updateTripContinuosly()
						stopWatch.startTimer()
					}
				}
			}
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
		bottomContainer = AnyView(
			//ScootersRow(scooterList: scooterList)
			ScrollView(.horizontal, showsIndicators: false) {
				HStack {
					ForEach(0..<scooterList.count) { index in
						ScooterCard(scooter: scooterList[index], onUnlock: {
							mapViewModel.selectedScooter = scooterList[index]
							showUnlockMethods()
						})
					}
				}
				.padding(.leading, 10)
				.padding(.bottom, 20)
			}
		)
	}
	
	func showUnlockMethods() {
		bottomContainer = AnyView(UnlockScooterMethods(unlockMethod: { unlockType in
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
		
		bottomContainer = AnyView(CodeUnlock(unlockViewModel: UnlockViewModel(scooter: selectedScooter, userLocation: getUserCoordinates() ) , onClose: {
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
				unwrapScooter { scooter in
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
		bottomContainer = AnyView(FinishTrip(tripRegion: tripViewModel.tripRegion, onFinish: {
			Session.ongoingTrip = false
			mapViewModel.selectedScooter = nil
			mapViewModel.getAvailableScooters()
			stopWatch.resetTimer()
			bottomContainer = AnyView(EmptyView())
		}))
	}

	func getUserCoordinates() -> [Double] {
		var userCoordinates: [Double] = []
		guard let coordinates = mapViewModel.locationManager.location else { return [0.0, 0,0] }
		userCoordinates.append(coordinates.coordinate.latitude)
		userCoordinates.append(coordinates.coordinate.longitude)
		return userCoordinates
	}
	
	private func unwrapScooter(_ callback: @escaping (Scooter) -> Void) {
		guard let scooter = tripViewModel.currentTripScooter else {
			showError(error: "No selected scooter")
			return
		}
		callback(scooter)
	}
		
	func menuCoordinator() {
		navigationStack.push(MenuCoordinator().environmentObject(tripViewModel))
	}
}
