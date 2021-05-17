//
//  AuthCoordinator.swift
//  Move
//
//  Created by Sergiu Corbu on 17.05.2021.
//

import Foundation
import NavigationStack
import SwiftUI

struct AuthCoordinator: View {
	@State private var isLoading = false
	@ObservedObject var navigationStack: NavigationStack
	
	var body: some View {
		Onboarding(onFinished: { registerCoordinator() })
	}
	
	func registerCoordinator() {
		navigationStack.push(Register(onRegisterComplete: { validationCoordinator()
		}, onLoginSwitch: {
			navigationStack.push(
				Login(onLoginCompleted: { mapCoodinator() },
					  onRegisterSwitch: { registerCoordinator() }))
		}))
	}
	
	func validationCoordinator() {
		navigationStack.push(
			ValidationInfo(isLoading: $isLoading, onBack: { navigationStack.pop()
			}, onNext: { image in
				uploadImage(image: image) }))
	}
	
	func uploadImage(image: Image) {
		isLoading = true
		DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
			isLoading = false
			navigationStack.push(ValidationSuccess(onFindScooters: { mapCoodinator() }))
		})
	}
	
	func mapCoodinator() {
		navigationStack.push(MapCoordinator(navigationStack: navigationStack))
	}
}

