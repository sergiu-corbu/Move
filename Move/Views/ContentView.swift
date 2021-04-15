//
//  ContentView.swift
//  Move
//
//  Created by Sergiu Corbu on 4/7/21.
//

import SwiftUI
import NavigationStack

struct ContentView: View {
    var body: some View {
        NewUser()
        //MapView()
    }
}

struct OpenLogin: View { //todo
    
    @ObservedObject var navigationViewModel: NavigationStack = NavigationStack()
    
    var body: some View {
        EmptyView()
    }
}

struct NewUser: View {
    @ObservedObject var navigationViewModel: NavigationStack = NavigationStack()
    
    var body: some View {
        NavigationStackView(navigationStack: navigationViewModel) {
            Onboarding {
                handleRegister()
            }
        }
    }
    
    func handleRegister() {
        navigationViewModel
            .push(
                Register(onRegisterComplete: {
                    navigationViewModel.push(ValidationInfo(onBack: navigationViewModel.pop()))
                }))
    }
}
