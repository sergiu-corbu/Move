//
//  MenuView.swift
//  Move
//
//  Created by Sergiu Corbu on 16.04.2021.
//

import SwiftUI

struct MenuView: View {
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading) {
                navBar
                historyView
                menuOptions
                Spacer()
            }
            // Image("scooter-img")
            //    .aspectRatio(contentMode: .fill)
        }
        .padding([.leading, .trailing], 24)
        .background(Color.white)
    }
    
    var navBar: some View {
        NavigationBar(title: "Hi, Sergiu!", avatar: "avatar-img", backButton: "chevron-left-purple", action: {})
            .padding(.top, 20)
            .padding(.bottom, 40)
    }
    var historyView: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 28)
                .foregroundColor(.lightPurple)
                .frame(width: .infinity, height: 100)
                .background(Image("history-background-img").resizable())
            HStack {
                VStack(alignment: .leading) {
                    Text("History")
                        .foregroundColor(.white)
                        .font(.custom(FontManager.Primary.bold, size: 18))
                    Text("Total rides: 20")
                        .foregroundColor(.fadePurple)
                        .font(.custom(FontManager.Primary.medium, size: 16))
                }
                Spacer()
                Button(action: {
                   
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
        }.padding(.bottom, 30)
    }
    
    var menuOptions: some View {
        VStack(alignment: .leading) {
            //MenuItems(icon: "wheel-img", title: "General Settings", components: [MenuSubItems(title: "Account", url: <#T##String?#>)])
            MenuItems(icon: "flag-img", title: "Legal", components: [SubMenuItems(title: "Terms and Conditions", url: "https://tapptitude.com", index: 0), SubMenuItems(title: "Privacy Policy", url: "https://tapptitude.com", index: 1)])
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
                    .padding(.trailing, 16)
                VStack(alignment: .leading) {
                    Text(title)
                        .foregroundColor(.darkPurple)
                        .font(.custom(FontManager.Primary.bold, size: 18))
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

struct SubMenuItems: View, Hashable {
    let title: String!
    let url: String!
    let index: Int
    var body: some View {
        Link(destination: URL(string: url)!, label: {
            Text(title)
                .foregroundColor(.darkPurple)
                .font(.custom(FontManager.Primary.regular, size: 16))
        })
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}
