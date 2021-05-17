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
		if Session.tokenKey != nil {
			NavigationStackView(navigationStack: navigationStack) {
				MapCoordinator(navigationStack: navigationStack)
			} } else {
				NavigationStackView(navigationStack: navigationStack) {
					AuthCoordinator(navigationStack: navigationStack)
				}
			}
	}
}
