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

struct MapCoordinator: View {
	@ObservedObject var mapViewModel: MapViewModel = MapViewModel.shared
	@State var container: AnyView = AnyView(EmptyView())
	var navigationStack: NavigationStack
	
	var body: some View {
		NavigationStackView(navigationStack: navigationStack) {
			ZStack(alignment: .bottom) {
				MapView(mapViewModel: mapViewModel, currentScooter: $mapViewModel.selectedScooter, onMenu: {  handleOnMenu() }, callBack: { scooter in
					container = AnyView(ScooterViewItem(scooter: scooter, onUnlock: {
						container = AnyView(UnlockScooterMethods(unlockMethod: { unlockType in
							handleUnlockType(type: unlockType)
						}))
					}))
				})
				container
			}
		}
	}
	
	
	func handleCodeUnlock() {
		navigationStack.push(CodeUnlock(onClose: { navigationStack.pop() },
									   onFinished: {
										container = AnyView(UnlockSuccesful(onFinished: {
											container = AnyView(StartRide(onStartRide: {
												container = AnyView(TripDetailView(onEndRide: {
													container = AnyView(FinishTrip(onFinish: {
														container = AnyView(EmptyView())
													}))
												}))
											}))
										}))
					}
		))
	}
	
	func handleUnlockType(type: UnlockType) {
		switch type {
			case .code: handleCodeUnlock()
			case .qr: break
			case .nfc: break
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

/*
//				if let selectedScooter = self.mapViewModel.selectedScooter {
//					container = AnyView(ScooterViewItem(scooter: selectedScooter))
//				}
//					container = AnyView(ScooterViewItem(scooter: selectedScooter))
//				}
//					UnlockScooterMethods(unlockMethod: { unlockType  in
//
//					}, scooter: selectedScooter)


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
//				}*/
