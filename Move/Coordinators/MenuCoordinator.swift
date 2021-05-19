//
//  MenuCoordinator.swift
//  Move
//
//  Created by Sergiu Corbu on 19.05.2021.
//

import SwiftUI
import NavigationStack

struct MenuCoordinator: View {
	
	@ObservedObject var navigationStack: NavigationStack
	
    var body: some View {
		NavigationStackView(navigationStack: navigationStack) {
			Menu(onBack: { }, onSeeAll: {
				
			}, onAccount: {
				
			}, onChangePassword: {
				
			})
		}
    }
}

struct MenuCoordinator_Previews: PreviewProvider {
    static var previews: some View {
        MenuCoordinator()
    }
}
