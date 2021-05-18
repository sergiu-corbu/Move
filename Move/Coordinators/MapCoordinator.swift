//
//  MapCoordinator.swift
//  Move
//
//  Created by Sergiu Corbu on 17.05.2021.
//

import Foundation
import NavigationStack
import SwiftUI

struct MapCoordinator: View {
	@ObservedObject var mapViewModel: MapViewModel = MapViewModel.shared
	@ObservedObject var tripViewModel: TripViewModel = TripViewModel.shared
	@ObservedObject var navigationStack: NavigationStack
	@State var bottomContainer: AnyView
	
	var body: some View {
		ZStack(alignment: .bottom) {
			InteractiveMap(mapViewModel: mapViewModel,tripViewModel: tripViewModel, onMenu: {  menuCoordinator() }, mapDataCallback: { trip, selectedScooter in
				if let trip = trip {
					print(trip.scooter.id)
					if trip.ongoing {
						showTripDetail(selectedScooter: selectedScooter)
					}
				} else {
					showScooterCard(selectedScooter: selectedScooter)
				}
			})
			bottomContainer
		}
	}
	
	func unlckTypeCoordinator(selectedScooter: Scooter, type: UnlockType) {
		switch type {
			case .code: showCode(selectedScooter: selectedScooter)
			case .qr: showQR(selectedScooter: selectedScooter)
			case .nfc: showNFC(selectedScooter: selectedScooter)
		}
	}
	
	func showUnlockMethods(selectedScooter: Scooter) {
		bottomContainer = AnyView(UnlockScooterMethods(scooter: selectedScooter, unlockMethod: { unlockType in
			unlckTypeCoordinator(selectedScooter: selectedScooter, type: unlockType)
		}))
	}
	
	func showCode(selectedScooter: Scooter) {
		bottomContainer = AnyView(CodeUnlock(onClose: {
			showUnlockMethods(selectedScooter: selectedScooter)
		}, onFinished: {
			showUnlockSuccess(selectedScooter: selectedScooter)
		}, unlockMethod: { unlockType in
			unlckTypeCoordinator(selectedScooter: selectedScooter, type: unlockType)
		}))
	}
	
	func showNFC(selectedScooter: Scooter) {
		bottomContainer = AnyView(NFCUnlock(onClose: { showUnlockMethods(selectedScooter: selectedScooter)
		}, onFinished: {
			// start ride..
		}, unlockMethod: { unlockType in
			unlckTypeCoordinator(selectedScooter: selectedScooter, type: unlockType)
		}))
	}
	
	func showQR(selectedScooter: Scooter) {
		bottomContainer = AnyView(QRUnlock(onClose: { showUnlockMethods(selectedScooter: selectedScooter)}, unlockMethod: { unlockType in
			unlckTypeCoordinator(selectedScooter: selectedScooter, type: unlockType)
		}))
	}
	
	func showScooterCard(selectedScooter: Scooter) {
		bottomContainer = AnyView(ScooterCard(scooter: selectedScooter, onUnlock: {
			showUnlockMethods(selectedScooter: selectedScooter)
		}, onDragDown: {
			bottomContainer = AnyView(EmptyView())
			mapViewModel.selectedScooter = nil
		}))
	}
	
	func showUnlockSuccess(selectedScooter: Scooter) {
		bottomContainer = AnyView(UnlockSuccesful(onFinished: {
			bottomContainer = AnyView(StartRide(scooter: selectedScooter,  onStartRide: {
				showStartRide(selectedScooter: selectedScooter)
			}))
		}))
	}

	func showStartRide(selectedScooter: Scooter) {
		bottomContainer = AnyView(StartRide(scooter: selectedScooter , onStartRide: {
			showTripDetail(selectedScooter: selectedScooter)
		}))
	}
	
	func showTripDetail(selectedScooter: Scooter) {
		bottomContainer = AnyView(TripDetail(tripViewModel: tripViewModel, scooter: selectedScooter, onEndRide: {
			showFinishTrip()
		}))
	}
	
	func showFinishTrip() {
		bottomContainer = AnyView(FinishTrip(tripViewModel: tripViewModel, onFinish: {
			Session.ongoingTrip = false
			mapViewModel.selectedScooter = nil
			mapViewModel.getAvailableScooters()
			tripViewModel.updateTrip()
			bottomContainer = AnyView(EmptyView())
		}))
	}
	
	//MARK: Menu navigation
	func menuCoordinator() {
		navigationStack.push(Menu(tripViewModel: tripViewModel, onBack: { navigationStack.pop() },
					 onSeeAll: { historyCoordinator() },
					 onAccount: { accountCoordinator() },
					 onChangePassword: { passwordCoordinator() }))
	}
	
	func accountCoordinator() {
		navigationStack.push(Account(onBack: { navigationStack.pop() },
					onLogout: { navigationStack.push(ContentView())},
					onSave: { navigationStack.pop() }))
	}
	
	func historyCoordinator() {
		navigationStack.push(History(tripViewModel: tripViewModel, onBack: { navigationStack.pop() }))
	}
	
	func passwordCoordinator() {
		navigationStack.push(ChangePassword(action: {navigationStack.pop()}))
	}
}
