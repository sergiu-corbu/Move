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
		}, onLoginSwitch: { loginCoordinator() }))
	}
	
	func validationCoordinator() {
		navigationStack.push(ValidationInfo(isLoading: $isLoading, onBack: { navigationStack.pop() }, onNext: { image in
				uploadImage(image: image)
			}))
	}

	func uploadImage(image: Image) {
		isLoading = true
		API.uploadLicense(selectedImage: image) { result in
			switch result {
				case .success:
					Session.licenseVerified = true
					navigationStack.push(ValidationSuccess(onFindScooters: { mapCoodinator() }))
				case .failure(let error):
					showError(error: error.localizedDescription)
			}
			isLoading = false
		}
	}
	
	func mapCoodinator() {
		navigationStack.push(MapCoordinator(navigationStack: navigationStack, bottomContainer: AnyView(EmptyView())))
	}
	func loginCoordinator() {
		navigationStack.push(Login(onLoginCompleted: { mapCoodinator() },
				  onRegisterSwitch: { registerCoordinator() }))
	}
}

