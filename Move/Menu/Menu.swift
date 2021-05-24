//
//  Menu.swift
//  Move
//
//  Created by Sergiu Corbu on 16.04.2021.
//

import SwiftUI

struct Menu: View {
	
	@EnvironmentObject var tripViewModel: TripViewModel
	
	let menuNavigation: (MenuNavigation) -> Void
	
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Image("scooter-img")
                .resizable()
                .frame(width: 250, height: 300)
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading) {
					NavigationBar(title: Session.username != nil ? "Hi, \(Session.username!)!" : "No user", color: .darkPurple, avatar: "avatar-img", backButton: "chevron-left-purple", action: {
						menuNavigation(.goBack)
					})
                    historyView
                    menuOptions
                    Spacer()
                }
            }
			.padding(.horizontal, 24)
        }
		.background(Color.white.edgesIgnoringSafeArea(.all))
		.onAppear {
			tripViewModel.downloadTrips(pageSize: 10)
		}
    }
	
    var historyView: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 28)
                .foregroundColor(.lightPurple)
                .frame(height: 110)
                .background(
					Image("history-background-img")
						.resizable()
				)
            HStack {
                VStack(alignment: .leading) {
                    Text("History")
                        .foregroundColor(.white)
                        .font(.custom(FontManager.Primary.bold, size: 18))
					Text("Total rides: \(tripViewModel.tripCount)")
                        .foregroundColor(.fadePurple)
                        .font(.custom(FontManager.Primary.medium, size: 16))
                }
                Spacer()
				Button(action: {
					menuNavigation(.goToHistory)
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
						.background(
							RoundedRectangle(cornerRadius: 16)
								.foregroundColor(.coralRed)
						)
				})
			}
			.padding(.horizontal, 30)
        }
		.padding(.top, 20)
    }
    var menuOptions: some View {
        VStack(alignment: .leading) {
            MenuItems(icon: "wheel-img", title: "General Settings", components: [
						SubMenuItems(title: "Account", index: 0, isLink: false, callback: { menuNavigation(.goToAccount) }),
						SubMenuItems(title: "Change password",index: 1, isLink: false, callback: { menuNavigation(.goToChangePassword) })
			])
			MenuItems(icon: "flag-img", title: "Legal", components: [
						SubMenuItems(title: "Terms and Conditions", index: 0, url: "https://google.com"),
						SubMenuItems(title: "Privacy Policy", index: 1, url: "https://google.com")])
			MenuItems(icon: "star-img", title: "Rate Us", components: []) {
				UIApplication.shared.open(URL(string: "itms-apps://itunes.apple.com/")!)
			}
        }
    }
}

struct MenuItems: View {
    
    let icon: String
    let title: String
    let components: [SubMenuItems]
	var action: (() -> Void)?
    
    var body: some View {
        VStack (alignment: .leading) {
            HStack(alignment: .top) {
                Image(icon)
                    .padding([.top, .trailing], 20)
                VStack(alignment: .leading) {
					if let action = action {
						Button(action: {
							action()
						}, label: {
							customText
						})
					} else {
						customText
					}
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
	
	var customText: some View {
		Text(title)
			.foregroundColor(.darkPurple)
			.font(.custom(FontManager.Primary.bold, size: 18))
			.padding(.vertical, 20)
	}
}

struct SubMenuItems: View {
    
    let title: String
	let index: Int
	var isLink: Bool = true
	var url: String?
	var callback: (() -> Void)?
   
	var body: some View {
		if isLink {
			if let url = url {
				Link(destination: URL(string: url)!, label: { text })
			}
		} else {
			Button(action: { callback?() }, label: { text })
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
			Menu(menuNavigation: { _ in })
                .previewDevice(PreviewDevice(rawValue: deviceName))
                .previewDisplayName(deviceName)
        }
        .preferredColorScheme(.dark)
    }
}
