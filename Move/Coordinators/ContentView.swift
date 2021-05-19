//
//  ContentView.swift
//  Move
//
//  Created by Sergiu Corbu on 4/7/21.
//
import SwiftUI
import NavigationStack

struct ContentView: View {
	
	@StateObject var navigationStack: NavigationStack = NavigationStack()
	
	var body: some View {
		
		if Session.tokenKey != nil && Session.licenseVerified && !Session.userSuspended {
			NavigationStackView(navigationStack: navigationStack) {
				MapCoordinator(navigationStack: navigationStack, bottomContainer: AnyView(EmptyView()))
			} } else {
				NavigationStackView(navigationStack: navigationStack) {
					AuthCoordinator(navigationStack: navigationStack)
				}
			}
	}
}
