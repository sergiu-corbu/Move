//
//  ContentView.swift
//  Move
//
//  Created by Sergiu Corbu on 4/7/21.
//

import SwiftUI
import NavigationStack

struct ContentView: View {
    
    @StateObject var statusBarConfigurator = StatusBarConfigurator()
    
    var body: some View {
		//ResetPassword(onBack: {}) errorrrrr
		
        if Session.tokenKey != nil {
            LoggedUser()
                .prepareStatusBarConfigurator(statusBarConfigurator)
                .onAppear {
                    statusBarConfigurator.statusBarStyle = .darkContent
                }
        } else {
            FirstOpen()
                .prepareStatusBarConfigurator(statusBarConfigurator)
                .onAppear {
                    statusBarConfigurator.statusBarStyle = .lightContent
                }
        }
	}
}

struct FirstOpen: View {
    
    @State private var isLoading = false
    @ObservedObject var navigationViewModel: NavigationStack = NavigationStack()
    
    var body: some View {
        NavigationStackView(navigationStack: navigationViewModel) {
            Onboarding(onFinished: {
                handleRegister()
            })
        }
    }
    
    func handleRegister() {
        navigationViewModel.push(Register(onRegisterComplete: {
            navigationViewModel.push(ValidationInfo(isLoading: $isLoading, onBack: {navigationViewModel.pop()}, onNext: { image in
                uploadImage(image: image)
            }))
        }, onLoginSwitch: {
            navigationViewModel.push(
                Login(onLoginCompleted: {
                    handleMap()
                }, onRegisterSwitch: {
                    handleRegister()
                })
            )}))
    }
    
    func uploadImage(image: Image) {
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
            isLoading = false
            navigationViewModel.push(ValidationSuccess(onFindScooters: {
                handleMap()
            }))
        })
    }
    
    func handleMap() {
        navigationViewModel.push(MapView(onMenuButton: {
            navigationViewModel.push(MenuView(onBack: {
                navigationViewModel.pop()
            }, onSeeAll: {
                navigationViewModel.push(HistoryView(onBack: {
                    navigationViewModel.pop()
                }))
            }, onAccount: {
                navigationViewModel.push(AccountView(onBack: {
                    navigationViewModel.pop()
                }, onLogout: {
                    navigationViewModel.push(FirstOpen())
                }, onSave: {
                    navigationViewModel.pop()
                }))
            }, onChangePassword: {
                navigationViewModel.push(ChangePasswordView(onBack: {
                    navigationViewModel.pop()
                }, onSave: {
                    navigationViewModel.pop()
                }))

            }
            ))
        }))
    }
}

struct LoggedUser: View {
    @ObservedObject var navigationViewModel: NavigationStack = NavigationStack()
    
    var body: some View {
        NavigationStackView(navigationStack: navigationViewModel) {
            MapView(onMenuButton: {
                handleOnMenu()
            })
        }
    }
    
    func handleOnMenu() {
            navigationViewModel.push(MenuView(onBack: {
                navigationViewModel.pop()
            }, onSeeAll: {
                navigationViewModel.push(HistoryView(onBack: {
                    navigationViewModel.pop()
                }))
            }, onAccount: {
                navigationViewModel.push(AccountView(onBack: {
                    navigationViewModel.pop()
                }, onLogout: {
                    navigationViewModel.push(FirstOpen())
                }, onSave: {
                    navigationViewModel.pop()
                }))
            }, onChangePassword: {
                navigationViewModel.push(ChangePasswordView(onBack: {
                    navigationViewModel.pop()
                }, onSave: {
                    navigationViewModel.pop()
                }))
                
            }))
    }
}

