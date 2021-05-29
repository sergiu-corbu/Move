//
//  ContentView.swift
//  Move
//
//  Created by Sergiu Corbu on 4/7/21.
//
import SwiftUI
import NavigationStack
import MapKit

struct ContentView: View {
	
	@StateObject var navigationStack: NavigationStack = NavigationStack()
	
	var body: some View {
		if Session.tokenKey != nil && Session.licenseVerified {
			NavigationStackView(navigationStack: navigationStack) {
				MapCoordinator(navigationStack: navigationStack, bottomContainer: AnyView(EmptyView()))
					.onReceive(Session.shared.objectWillChange) { _ in
						navigationStack.push(ContentView())
				}
			} } else {
				NavigationStackView(navigationStack: navigationStack) {
					AuthCoordinator(navigationStack: navigationStack)
				}
		}
	}
}
