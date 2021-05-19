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
	@StateObject var tripViewModel: TripViewModel = TripViewModel()
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
				if tripViewModel.ongoing {
					unwrapScooter { scooter in
						showTripDetail(currentScooter: scooter)
					}
				}
			}
		}
		.environmentObject(tripViewModel)
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
			tripViewModel.updateTrip {
				unwrapScooter { scooter in
					showTripDetail(currentScooter: scooter)
					stopWatch.startTimer()
				}
			}
		}))
	}
	
	func showTripDetail(currentScooter: Scooter) {
		bottomContainer = AnyView(TripDetail(stopWatch: stopWatch, scooter: currentScooter , onEndRide: {
			showFinishTrip()
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
	
	//MARK: Menu navigation
	func menuCoordinator() {
		navigationStack.push(Menu(onBack: { navigationStack.pop() },
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
		navigationStack.push(History(onBack: { navigationStack.pop() }))
	}
	
	func passwordCoordinator() {
		navigationStack.push(ChangePassword(action: {navigationStack.pop()}))
	}
	
	private func unwrapScooter(_ callback: @escaping (Scooter) -> Void) {
		guard let scooter = tripViewModel.currentTripScooter else {
			showError(error: "No selected scooter")
			return
		}
		callback(scooter)
	}
}
