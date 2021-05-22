//
//  MenuCoordinator.swift
//  Move
//
//  Created by Sergiu Corbu on 19.05.2021.
//

import SwiftUI
import NavigationStack

struct MenuCoordinator: View {
	
	@ObservedObject var navigationStack: NavigationStack = SceneDelegate.navigationStack
	@EnvironmentObject var tripViewModel: TripViewModel
	
    var body: some View {
		Menu(onBack: { navigationStack.pop() }, onSeeAll: {
			historyCoordinator()
		}, onAccount: {
			accountCoordinator()
		}, onChangePassword: {
			passwordCoordinator()
		})
		.environmentObject(tripViewModel)
    }

	func accountCoordinator() {
		navigationStack.push(Account(onBack: { navigationStack.pop() },
									 onLogout: { navigationStack.push(ContentView())},
									 onSave: { navigationStack.pop() }))
	}
	
	func historyCoordinator() {
		navigationStack.push(History(onBack: { navigationStack.pop() }).environmentObject(tripViewModel))
	}
	
	func passwordCoordinator() {
		navigationStack.push(ChangePassword(action: {navigationStack.pop()}))
	}
}
