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
	@State var bottomContainer: AnyView = AnyView(EmptyView())
	var navigationStack: NavigationStack
	
	var body: some View {
		NavigationStackView(navigationStack: navigationStack) {
			ZStack(alignment: .bottom) {
				InteractiveMap(mapViewModel: mapViewModel, currentScooter: $mapViewModel.selectedScooter, onMenu: {  menuCoordinator() }, onSelectedScooter: { scooter in
					bottomContainer = AnyView(ScooterCard(scooter: scooter, onUnlock: {
						bottomContainer = AnyView(UnlockScooterMethods(mapViewModel: mapViewModel, unlockMethod: { unlockType in
							unlckTypeCoordinator(type: unlockType)
						}))
					}))
				})
				bottomContainer
			}
		}
	}
	
	func unlckTypeCoordinator(type: UnlockType) {
		switch type {
			case .code: codeUnlockCoordinator()
			case .qr: qrCoordinator()
			case .nfc: nfcCoordinator()
		}
	}
	
	func codeUnlockCoordinator() {
		navigationStack.push(
			CodeUnlock(onClose: { navigationStack.pop() },
					   onFinished: {
						navigationStack.pop()
						bottomContainer = AnyView(UnlockSuccesful(onFinished: {
							startTripCoordinator()
						}))}
			))
	}
	
	func startTripCoordinator() {
		bottomContainer = AnyView(StartRide(mapViewModel: mapViewModel, onStartRide: {
			bottomContainer = AnyView(TripDetail(tripViewModel: tripViewModel, mapViewModel: mapViewModel, onEndRide: {
				bottomContainer = AnyView(FinishTrip(onFinish: {
					Session.ongoingTrip = false
					mapViewModel.selectedScooter = nil
					mapViewModel.getAvailableScooters()
					bottomContainer = AnyView(EmptyView())
				}))
			}))
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
	
	func menuCoordinator() {
		navigationStack.push(
			Menu(onBack: { navigationStack.pop() },
				 onSeeAll: { navigationStack.push(
					History(onBack: { navigationStack.pop() }))},
				 onAccount: { navigationStack.push(
					Account(onBack: { navigationStack.pop() },
							onLogout: { navigationStack.push(ContentView())},
							onSave: { navigationStack.pop() }))},
				 onChangePassword: { navigationStack.push(
					ChangePassword(action: {navigationStack.pop()}))
				 }))
	}
}
