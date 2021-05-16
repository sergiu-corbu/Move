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
	@StateObject var navigationStack: NavigationStack = NavigationStack()
	
	var body: some View {
		if Session.tokenKey != nil {
				MapCoordinator(navigationStack: navigationStack)
			 } else {
				AuthCoordinator(navigationStack: navigationStack)
		}
	}
}
	
//	func handleUnlockType(type: UnlockType, scooter: Scooter) {
//		switch type {
//			case .code: handleCodeUnlock(scooter: scooter)
//			case .qr: break
//			case .nfc: break
//		}
//	}
//	
//	func handleCodeUnlock(scooter: Scooter) {
//		navigationViewModel.push(SNUnlock(onClose: {navigationViewModel.pop()}, onFinished: {
//			navigationViewModel.push(UnlockSuccesful())
//			DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
//				navigationViewModel.push(StartRide(scooter: scooter, onStartRide: {scooter in
//					navigationViewModel.push(TripDetailView(tapped: false, scooter: scooter, onEndRide: {
//						navigationViewModel.push(TripSummary())
//					}))
//				}))
//			})
//		}))
//	}

struct MapCoordinator: View {
	var navigationStack: NavigationStack
	@ObservedObject var mapViewModel: MapViewModel = MapViewModel.shared
	
	@State private var unlockPressed: Bool = false
	@State private var pinPressed = false
	@State var showUnlock = false
	@State var showTrip = false
	@State var showTripDetails = false
	@State var showSummary = false
	@State var showScooterCard = true
	
	var body: some View {
		NavigationStackView(navigationStack: navigationStack) {
			ZStack(alignment: .bottom) {
				MapView(mapViewModel: mapViewModel, onMenu: {  handleOnMenu() })
					.onTapGesture {
						mapViewModel.selectedScooter = nil
						unlockPressed = false
						showScooterCard = true
					}
				if let selectedScooter = self.mapViewModel.selectedScooter {
					if showScooterCard {
						ScooterViewItem(scooter: selectedScooter, isUnlocked: $unlockPressed, onTapp: {showScooterCard = false})
					} else if unlockPressed {
						UnlockScooterMethods(onQR: {}, onPin: { pinPressed = true }, onNFC: {}, scooter: selectedScooter)
					}
//					if showTrip {
//						StartRide(scooter: selectedScooter, onStartRide: { scooter in
//							showTripDetails = true
//							unlockPressed = false
//							showTrip = false
//							Session.ongoingTrip = true
//							self.mapViewModel.getAvailableScooters()
//						})
//					}
//					if showTripDetails {
//						TripDetailView(scooter: selectedScooter, onEndRide: {
//							mapViewModel.selectedScooter = nil
//							showTripDetails = false
//							showSummary = true
//						})
//					}
				}
//				if pinPressed {
//					CodeUnlock(onClose: {pinPressed = false}, onFinished: {
//						showUnlock = true
//						pinPressed = false
//					})
//				}
//				if showUnlock {
//					UnlockSuccesful(onFinished: {
//						showUnlock = false
//						showTrip = true
//						unlockPressed = false
//					})
//				}
//				if showSummary {
//					FinishTrip(onFinish: {
//						Session.ongoingTrip = false
//						showSummary = false
//						showScooterCard = true
//						mapViewModel.getAvailableScooters()
//					})
//				}
			}
		}
	}
	
	func handleOnMenu() {
		navigationStack.push(MenuView(onBack: { navigationStack.pop() },
										  onSeeAll: { navigationStack.push(HistoryView(onBack: { navigationStack.pop() }))
										  }, onAccount: {
											navigationStack.push(AccountView(onBack: { navigationStack.pop() }, onLogout: { navigationStack.push(ContentView())}, onSave: { navigationStack.pop() }))
										}, onChangePassword: { navigationStack.push(ChangePasswordView(action: {navigationStack.pop()})) }))
	}
}



struct AuthCoordinator: View {
	var navigationStack: NavigationStack
	@State private var isLoading = false
	
	var body: some View {
		NavigationStackView(navigationStack: navigationStack) {
			Onboarding(onFinished: { handleRegister() })
		}
	}
	
	func handleRegister() {
		navigationStack.push(Register(onRegisterComplete: { handleValidation()
		}, onLoginSwitch: {
			navigationStack.push(
				Login(onLoginCompleted: { handleMap() },
					  onRegisterSwitch: { handleRegister() })
			)}))
	}
	
	func handleValidation () {
		navigationStack.push(
			ValidationInfo(isLoading: $isLoading, onBack: { navigationStack.pop()
			}, onNext: { image in
				uploadImage(image: image) }))
	}
	
	func uploadImage(image: Image) {
		isLoading = true
		DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
			isLoading = false
			navigationStack.push(ValidationSuccess(onFindScooters: { handleMap() }))
		})
	}
	
	func handleMap() {
		navigationStack.push(MapCoordinator(navigationStack: navigationStack))
	}
}
