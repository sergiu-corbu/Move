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
        
       // if Session.tokenKey != nil {
            MapViewNavigation()
      //  } else {
      //      NewUser()
      //  }
        //ValidationNavigation()
        //NewUser()
       // MapViewNavigation()
        //MenuView()
    }
}

struct ValidationNavigation: View {
    @State private var isLoading = false
    @ObservedObject var navigationViewModel: NavigationStack = NavigationStack()
    var body: some View {
        NavigationStackView(navigationStack: navigationViewModel) {
            ValidationInfo(isLoading: $isLoading, onBack: {
                navigationViewModel.pop()
            }, onNext: { image in
                uploadImage(image: image)
            })
        }
    }
    
    func uploadImage(image: Image) {
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
            isLoading = false
            navigationViewModel
                .push(ValidationViewNavigation())
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
                navigationViewModel.push(RegisterNavigation())
            }
        }
    }
}

struct RegisterNavigation: View {
    @ObservedObject var navigationViewModel: NavigationStack = NavigationStack()
    
    var body: some View {
        NavigationStackView(navigationStack: navigationViewModel) {
            Register(onRegisterComplete: {
                navigationViewModel.push(ValidationNavigation())
            }, onLoginSwitch: {
                navigationViewModel.push(LoginNavigation())
            })
        }
    }
}


