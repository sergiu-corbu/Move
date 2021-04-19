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
        //ValidationNavigation()
        //NewUser()
        MapViewNavigation()
        //MenuView()
    }
}

struct ValidationNavigation: View {
    @State private var isLoading = false
    @ObservedObject var navigationViewModel: NavigationStack = NavigationStack()
    var body: some View {
        NavigationStackView(navigationStack: navigationViewModel) {
            ValidationInfo(isLoading: $isLoading, onBack: (), onNext: { image in
                uploadImage(image: image)
            })
        }
    }
    
    func uploadImage(image: Image) {
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
            isLoading = false
            navigationViewModel
                .push(ValidationInProgress())
        })
    }
}

struct LoginNavigation: View {
    @ObservedObject var navigationViewModel: NavigationStack = NavigationStack()
    
    var body: some View {
        NavigationStackView(navigationStack: navigationViewModel) {
            Login(onLoginCompleted: {
                navigationViewModel.push(MapViewNavigation())
            }, onRegisterSwitch: {
                navigationViewModel.push(RegisterNavigation())
            })
        }
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
            .push(RegisterNavigation())
    }
    
}

struct RegisterNavigation: View {
    @ObservedObject var navigationViewModel: NavigationStack = NavigationStack()
    
    var body: some View {
        NavigationStackView(navigationStack: navigationViewModel) {
            Register(onRegisterComplete: {
                handleValidation()
            }, onLoginSwitch: {
                handleLoginSwitch()
            })
        }
    }
    
    func handleLoginSwitch() {
        navigationViewModel.push(LoginNavigation())
    }
    func handleValidation() {
        navigationViewModel.push(ValidationNavigation())
    }
}

