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
	
	@ObservedObject var navigationStack: NavigationStack
	@StateObject var mapViewModel: MapViewModel = MapViewModel()
	@ObservedObject var tripViewModel: TripViewModel = TripViewModel.shared
	@StateObject var stopWatch: StopWatchViewModel = StopWatchViewModel()
	@State var bottomContainer: AnyView
	
	var body: some View {
		ZStack(alignment: .bottom) {
			InteractiveMap(tripViewModel: tripViewModel, onMenu: { menuCoordinator() }, onScooterSelected: {  selectedScooter in
					showScooterCard(selectedScooter: selectedScooter)
				})
			bottomContainer
		}
		.onAppear {
			tripViewModel.updateTrip() {
				if let currentTrip = tripViewModel.currentTrip {
					if currentTrip.trip.ongoing {
						tripViewModel.currentTrip = currentTrip
						showTripDetail()
					}
				}
			}
		}
		.environmentObject(mapViewModel)
	}
	
	func unlckTypeCoordinator(type: UnlockType) {
		switch type {
			case .code: showCode()
			case .qr: showQR()
			case .nfc: showNFC()
		}
	}
	
	func showScooterCard(selectedScooter: Scooter) {
		bottomContainer = AnyView(ScooterCard( onUnlock: {
			showUnlockMethods()
		}, onDragDown: {
			bottomContainer = AnyView(EmptyView())
			mapViewModel.selectedScooter = nil
		}))
	}
	
	func showUnlockMethods() {
		bottomContainer = AnyView(UnlockScooterMethods(unlockMethod: { unlockType in
			unlckTypeCoordinator( type: unlockType)
		}))
	}
	
	func showCode() {
		guard let selectedScooter = mapViewModel.selectedScooter else {
			return
		}
		bottomContainer = AnyView(CodeUnlock(unlockViewModel: UnlockViewModel(scooter: selectedScooter) , onClose: {
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
			showTripDetail()
			stopWatch.startTimer()
		}))
	}
	
	func showTripDetail() {
		bottomContainer = AnyView(TripDetail(stopWatch: stopWatch, tripViewModel: tripViewModel, onEndRide: {
			showFinishTrip()
		}))
	}
	
	func showFinishTrip() {
		bottomContainer = AnyView(FinishTrip(tripViewModel: tripViewModel, onFinish: {
			Session.ongoingTrip = false
			mapViewModel.selectedScooter = nil
			mapViewModel.getAvailableScooters()
			stopWatch.resetTimer()
			bottomContainer = AnyView(EmptyView())
		}))
	}
	
	//MARK: Menu navigation
	func menuCoordinator() {
		navigationStack.push(Menu(tripViewModel: tripViewModel,
					onBack: { navigationStack.pop() },
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
