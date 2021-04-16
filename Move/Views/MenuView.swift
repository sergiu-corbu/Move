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
                NavigationBar(title: "Hi, Sergiu!", avatar: "avatar-img", backButton: "chevron-left-purple", action: {}).padding(.top, 20)
                    .padding(.bottom, 85)
                historyView
            }
            Spacer()
        }
        .padding([.leading, .trailing], 24)
        .background(Color.white)
    }
    
    var historyView: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 28)
                .foregroundColor(.red)
               
                .background(Image("history-background-img").resizable())
                .frame(width: .infinity, height: 100)
            HStack {
                VStack(alignment: .leading) {
                    Text("Trips")
                    Text("Total rides: 20")
                }
                
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
            }
           
            
               
        }
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}
