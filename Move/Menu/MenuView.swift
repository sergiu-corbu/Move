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
	
	var isUser: Bool {
		if Session.username != nil { return true }
		else { return false }
	}
	
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Image("scooter-img")
                .resizable()
                .frame(width: 250, height: 300)
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading) {
					NavigationBar(title: isUser ? "Hi, \(Session.username!)!" : "No user", color: .darkPurple, avatar: "avatar-img", backButton: "chevron-left-purple", action: { onBack() })
                    historyView
                    menuOptions
                    Spacer()
                }
            }.padding(.horizontal, 24)
        }
		.onAppear{ downloadTrips() }
		.background(Color.white.edgesIgnoringSafeArea(.all))
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
				Button(action: { onSeeAll() }, label: {
						HStack {
							Text("See all")
								.foregroundColor(.white)
								.font(.custom(FontManager.Primary.bold, size: 18))
								.transition(.opacity)
							Image(systemName: "arrow.right")
								.foregroundColor(.white)
						}
						.padding(.all, 16)
						.background(Rectangle().foregroundColor(.coralRed).cornerRadius(16))})
			}.padding(.horizontal, 30)
        }.padding(.top, 20)
    }
    var menuOptions: some View {
        VStack(alignment: .leading) {
            MenuItems(icon: "wheel-img", title: "General Settings", components: [SubMenuItems(title: "Account", index: 0, callback: { onAccount()}, isNavButton: true, url: "a"),
				SubMenuItems(title: "Change password",index: 1, callback: { onChangePassword() }, isNavButton: true, url: "a")])
            MenuItems(icon: "flag-img", title: "Legal", components: [SubMenuItems(title: "Terms and Conditions", index: 0, url: "https://tapptitude.com"), SubMenuItems(title: "Privacy Policy", index: 1, url: "https://tapptitude.com")])
            MenuItems(icon: "star-img", title: "Rate Us", components: [])
        }
    }
	
	func downloadTrips() {
		API.downloadTrips({ result in
			switch result {
				case .success(let trips): tripViewModel.allTrips = trips
				case .failure(let error): showError(error: error.localizedDescription)
			}
		})
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
						.padding(.vertical, 20)
                    if components.count > 0 {
                        ForEach(0..<components.count) { index in
                            components[index]
								.padding(.vertical, 15)
                        }
                    }
                }
            }
        }
    }
}

struct SubMenuItems: View {
    
    let title: String
	let index: Int
	var callback: (() -> Void)?
    var isNavButton: Bool = false
    var url: String
    
    var body: some View {
        if isNavButton {
            Link(destination: URL(string: url)!, label: { text })
        } else {
            Button(action: { callback!() }, label: { text })
        }
    }
	
	var text: some View {
		Text(title)
			.foregroundColor(.darkPurple)
			.font(.custom(FontManager.Primary.regular, size: 16))
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
