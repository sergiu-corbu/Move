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
	@State var bottomContainer: AnyView = AnyView(EmptyView())
	
	var body: some View {
		ZStack(alignment: .bottom) {
			InteractiveMap(mapViewModel: mapViewModel, onMenu: {  menuCoordinator() }, onSelectedScooter: { selectedScooter in
				bottomContainer = AnyView(ScooterCard(scooter: selectedScooter, onUnlock: {
					showUnlockMethods(selectedScooter: selectedScooter)
				}))
			})
			bottomContainer
		}
		.onAppear {
//			tripViewModel.updateTrip()
//			if tripViewModel.ongoingTrip.trip.ongoing {
//				showTripDetail(selectedScooter: )
//			}
		}
	}
	
	func unlckTypeCoordinator(selectedScooter: Scooter, type: UnlockType) {
		switch type {
			case .code: showCodeUnlock(selectedScooter: selectedScooter)
			case .qr: qrCoordinator()
			case .nfc: nfcCoordinator()
		}
	}
	
	func showUnlockMethods(selectedScooter: Scooter) {
		bottomContainer = AnyView(UnlockScooterMethods(scooter: selectedScooter, unlockMethod: { unlockType in
			unlckTypeCoordinator(selectedScooter: selectedScooter, type: unlockType)
		}))
	}
	
	func showCodeUnlock(selectedScooter: Scooter) {
		bottomContainer = AnyView(CodeUnlock(onClose: {
			showUnlockMethods(selectedScooter: selectedScooter)
		}, onFinished: {
			showUnlockSuccess(selectedScooter: selectedScooter)
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
			bottomContainer = AnyView(EmptyView())
		}))
	}
	
	
	func nfcCoordinator() {
		navigationStack.push(NFCUnlock(mapViewModel: mapViewModel, onClose: { navigationStack.pop()
		}, onFinished: {
			// start ride..
		}))
	}
	
	func qrCoordinator() {
		
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
