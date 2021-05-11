//
//  ContentView.swift
//  Move
//
//  Created by Sergiu Corbu on 4/7/21.
//

import SwiftUI
import NavigationStack

struct ContentView: View {
	@State private var isLoading = false
	var navigationViewModel: NavigationStack = NavigationStack()
	
	var body: some View {

		if Session.tokenKey != nil {
			NavigationStackView(navigationStack: navigationViewModel) {
				MapCoordinator(navigationViewModel: navigationViewModel) { unlockType, scooter in
					handleUnlockType(type: unlockType, scooter: scooter)
				}
			} } else {
			NavigationStackView(navigationStack: navigationViewModel) {
				Onboarding(onFinished: { handleRegister() })
			}
		}
	}
	
	func handleUnlockType(type: UnlockType, scooter: Scooter) {
		switch type {
			case .code: handleCodeUnlock(scooter: scooter)
			case .qr: break
			case .nfc: break
		}
	}
	
	func handleCodeUnlock(scooter: Scooter) {
		navigationViewModel.push(SNUnlock(onClose: {navigationViewModel.pop()}, onFinished: {
			navigationViewModel.push(UnlockSuccesful())
			DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
				navigationViewModel.push(StartRide(scooter: scooter, onStartRide: {scooter in
					navigationViewModel.push(TripDetailView(tapped: false, scooter: scooter, onEndRide: {
						navigationViewModel.push(TripSummary())
					}))
				}))
			})
		}))
	}
	
	func handleRegister() {
		navigationViewModel.push(Register(onRegisterComplete: {
			navigationViewModel.push(ValidationInfo(isLoading: $isLoading, onBack: { navigationViewModel.pop() }, onNext: { image in
				uploadImage(image: image) }))
		}, onLoginSwitch: {
			navigationViewModel.push(
				Login(onLoginCompleted: {  }, onRegisterSwitch: { handleRegister() })
			)}))
	}
	
	func uploadImage(image: Image) {
		isLoading = true
		DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
			isLoading = false
			navigationViewModel.push(ValidationSuccess(onFindScooters: { handleMap() }))
		})
	}
	
	func handleMap() {
		navigationViewModel.push(
		MapCoordinator(navigationViewModel: navigationViewModel) { unlockType, scooter in
			handleUnlockType(type: unlockType, scooter: scooter)
		})
	}
}
