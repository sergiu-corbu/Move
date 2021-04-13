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
        Register()
       // FirstOpen()
        //MapView()
    }
}

struct FirstOpen: View {
    @ObservedObject var navigationViewModel: NavigationStack = NavigationStack()
    
    var body: some View {
        NavigationStackView(navigationStack: navigationViewModel) {
            Onboarding {
                navigationViewModel.push(Register())
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
