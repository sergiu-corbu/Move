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
				MapView(onMenu: { handleOnMenu() }) { unlockType in
					handleUnlockType(type: unlockType)}
				}}
		else {
			NavigationStackView(navigationStack: navigationViewModel) {
				Onboarding(onFinished: {
					handleRegister()
				})
			}
		}
	}
	
	func handleUnlockType(type: UnlockType) {
		switch type {
			case .code:
				handleCodeUnlock()
			case .qr:
				break
			case .nfc:
				break
		}
	}
	
	func handleCodeUnlock() {
		navigationViewModel.push(SNUnlock(onClose: {navigationViewModel.pop()}))
	}
	
	func handleOnMenu() {
		navigationViewModel.push(MenuView(onBack: { navigationViewModel.pop()},
										  onSeeAll: { navigationViewModel.push(HistoryView(onBack: { navigationViewModel.pop() }))
										  }, onAccount: { navigationViewModel.push(AccountView(onBack: { navigationViewModel.pop() },
										onLogout: { navigationViewModel.push(Onboarding(onFinished: {handleRegister()})) },
										onSave: { navigationViewModel.pop() })) },
										  onChangePassword: { navigationViewModel.push(ChangePasswordView(onBack: { navigationViewModel.pop() }, onSave: { navigationViewModel.pop() }))}))
	}
	
	func handleRegister() {
		navigationViewModel.push(Register(onRegisterComplete: {
			navigationViewModel.push(ValidationInfo(isLoading: $isLoading, onBack: { navigationViewModel.pop() }, onNext: { image in
				uploadImage(image: image) }))
		}, onLoginSwitch: {
			navigationViewModel.push(
				Login(onLoginCompleted: { handleMap() }, onRegisterSwitch: { handleRegister() }) )}))
	}
	
	func uploadImage(image: Image) {
		isLoading = true
		DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
			isLoading = false
			navigationViewModel.push(ValidationSuccess(onFindScooters: { handleMap() }))
		})
	}
	
	func handleMap() {
		navigationViewModel.push(MapView(onMenu: { handleOnMenu() }, onUnlockType: { unlockType in
			handleUnlockType(type: unlockType)
		}))
	}

}
