//
//  AuthCoordinator.swift
//  Move
//
//  Created by Sergiu Corbu on 17.05.2021.
//

import NavigationStack
import SwiftUI

struct AuthCoordinator: View {
	@ObservedObject var navigationStack: NavigationStack = SceneDelegate.navigationStack
	
	var body: some View {
		Onboarding { authNavigation in
			handleAuthNavigation(type: authNavigation)
		}
	}
	
	func handleAuthNavigation(type: AuthNavigation) {
		switch type {
			case .back:
				navigationStack.pop()
			case .onboardingFinished, .switchToRegister:
				registerCoordinator()
			case .switchToLogin:
				loginCoordinator()
			case .registerCompleted:
				validationCoordinator()
			case .loginCompleted, .openMap:
				mapCoodinator()
			case .imageUploadCompleted:
				validationSuccess()
		}
	}
	
	func registerCoordinator() {
		navigationStack.push(Register { authNavigation in
				handleAuthNavigation(type: authNavigation)
		})
	}
	
	func loginCoordinator() {
		navigationStack.push(Login { authNavigation in
			handleAuthNavigation(type: authNavigation)
		})
	}
	
	func validationCoordinator() {
		navigationStack.push(ValidationInfo { authNavigation in
			handleAuthNavigation(type: authNavigation)
		})
	}
	
	func mapCoodinator() {
		navigationStack.push(MapCoordinator(bottomContainer: AnyView(EmptyView())))
	}
	
	func validationSuccess() {
		navigationStack.push(ValidationSuccess { authNavigation in
			handleAuthNavigation(type: authNavigation)
		})
	}
}
