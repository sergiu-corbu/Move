//
//  MenuCoordinator.swift
//  Move
//
//  Created by Sergiu Corbu on 19.05.2021.
//

import SwiftUI
import NavigationStack

struct MenuCoordinator: View {
	
	@EnvironmentObject var tripViewModel: TripViewModel
	@ObservedObject var navigationStack: NavigationStack = SceneDelegate.navigationStack
	
    var body: some View {
		Menu { menuNavigation in
			handleMenuNavigation(type: menuNavigation)
		}
		.environmentObject(tripViewModel)
    }
	
	func handleMenuNavigation(type: MenuNavigation) {
		switch type {
			case .goBack:
				navigationStack.pop()
			case .goToAccount:
				goToAccount()
			case .goToChangePassword:
				passwordCoordinator()
			case .goToHistory:
				goToHistory()
			case .logoutUser:
				navigationStack.push(AuthCoordinator())
		}
	}

	func goToAccount() {
		navigationStack.push(Account { accountNavigation in
				handleMenuNavigation(type: accountNavigation)
			})
	}
	
	func goToHistory() {
		navigationStack.push(History { historyNavigation in
				handleMenuNavigation(type: historyNavigation)
			}
			.environmentObject(tripViewModel)
		)
	}
	
	func passwordCoordinator() {
		navigationStack.push(ChangePassword { passwordNavigation in
			handleMenuNavigation(type: passwordNavigation)
		})
	}
}
