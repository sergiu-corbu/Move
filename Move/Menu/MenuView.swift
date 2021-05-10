//
//  MenuView.swift
//  Move
//
//  Created by Sergiu Corbu on 16.04.2021.
//

import SwiftUI

struct MenuView: View {
	@ObservedObject var tripViewModel: TripViewModel = TripViewModel.shared
	
    let onBack: () -> Void
    let onSeeAll: () -> Void
    let onAccount: () -> Void
    let onChangePassword: () -> Void

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Image("scooter-img")
                .resizable()
                .frame(width: 250, height: 300)
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading) {
					NavigationBar(title: "Hi, \(Session.username ?? "no user logged")!", color: .darkPurple, avatar: "avatar-img", backButton: "chevron-left-purple", action: { onBack() })
                    historyView
                    menuOptions
                    Spacer()
                }
            }
			.padding(.horizontal, 24)
        }
		.onAppear{
			API.downloadTrips({ result in
				switch result {
					case .success(let trips):
						print(trips)
						tripViewModel.allTrips = trips
					case .failure(let error):
						print(error)
				}
			})
		}
		.background(Color.white.ignoresSafeArea())
    }
	
    var historyView: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 28)
                .foregroundColor(.lightPurple)
                .frame(height: 110)
                .background(Image("history-background-img").resizable())
            HStack {
                VStack(alignment: .leading) {
                    Text("History")
                        .foregroundColor(.white)
                        .font(.custom(FontManager.Primary.bold, size: 18))
					Text("Total rides: \(tripViewModel.allTrips.count)")
                        .foregroundColor(.fadePurple)
                        .font(.custom(FontManager.Primary.medium, size: 16))
                }
                Spacer()
                Button(action: {
                   onSeeAll()
                }, label: {
                    HStack {
                        Text("See all")
                            .foregroundColor(.white)
                            .font(.custom(FontManager.Primary.bold, size: 18))
                            .transition(.opacity)
                        Image(systemName: "arrow.right")
                            .foregroundColor(.white)
                    }
                    .padding(.all, 16)
                    .background(Rectangle()
                                    .foregroundColor(.coralRed)
                                    .cornerRadius(16))})
            }.padding([.leading, .trailing], 30)
        }.padding(.top, 20)
    }
    var menuOptions: some View {
        VStack(alignment: .leading) {
            MenuItems(icon: "wheel-img", title: "General Settings", components: [SubMenuItems(title: "Account", isLink: false, isNavButton: true, url: "", index: 0, callback: {
                onAccount()
            }), SubMenuItems(title: "Change password", isLink: false, isNavButton: true, url: "", index: 1, callback: {
                onChangePassword()
            })])
            MenuItems(icon: "flag-img", title: "Legal", components: [SubMenuItems(title: "Terms and Conditions",isLink: true, isNavButton: false, url: "https://tapptitude.com", index: 0, callback: {}), SubMenuItems(title: "Privacy Policy", isLink: true, isNavButton: false, url: "https://tapptitude.com", index: 1, callback: {})])
            MenuItems(icon: "star-img", title: "Rate Us", components: [])
        }
    }
}

struct MenuItems: View {
    
    let icon: String
    let title: String
    let components: [SubMenuItems]
    
    var body: some View {
        VStack (alignment: .leading) {
            HStack(alignment: .top) {
                Image(icon)
                    .padding([.top, .trailing], 20)
                VStack(alignment: .leading) {
                    Text(title)
                        .foregroundColor(.darkPurple)
                        .font(.custom(FontManager.Primary.bold, size: 18))
                        .padding([.top, .bottom], 20)
                    if components.count > 0 {
                        ForEach(0..<components.count) { index in
                            components[index]
                                .padding([.top, .bottom], 15)
                        }
                    }
                }
            }
        }
    }
}

struct SubMenuItems: View {
    
    let title: String
    let isLink: Bool
    let isNavButton: Bool
    let url: String
    let index: Int
    let callback: () -> Void
    
    var body: some View {
        if isLink {
            Link(destination: URL(string: url)!, label: {
                Text(title)
                    .foregroundColor(.darkPurple)
                    .font(.custom(FontManager.Primary.regular, size: 16))
            })
        } else if isNavButton {
            Button(action: {
                callback()
            }, label: {
                Text(title)
                    .foregroundColor(.darkPurple)
                    .font(.custom(FontManager.Primary.regular, size: 16))
            })
        }
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(["iPhone SE (2nd generation)", "iPhone 12"], id: \.self) { deviceName in
			MenuView(tripViewModel: TripViewModel(), onBack: {}, onSeeAll: {}, onAccount: {}, onChangePassword: {})
                .previewDevice(PreviewDevice(rawValue: deviceName))
                .previewDisplayName(deviceName)
        }
        .preferredColorScheme(.dark)
    }
}
