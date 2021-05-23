//
//  ContentView.swift
//  Move
//
//  Created by Sergiu Corbu on 4/7/21.
//
import SwiftUI
import NavigationStack

struct ContentView: View {
	@StateObject var navigationStack: NavigationStack = SceneDelegate.navigationStack

	var body: some View {
		if Session.tokenKey != nil && Session.licenseVerified {
			NavigationStackView(navigationStack: navigationStack) {
				MapCoordinator(bottomContainer: AnyView(EmptyView()))
			} } else {
				NavigationStackView(navigationStack: navigationStack) {
					AuthCoordinator()
				}
			}
	}
}
