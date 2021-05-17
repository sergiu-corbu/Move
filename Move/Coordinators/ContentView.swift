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
			MapCoordinator(navigationStack: navigationStack)
		} else {
			AuthCoordinator(navigationStack: navigationStack)
		}
	}
}
