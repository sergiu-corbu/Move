//
//  HistoryView.swift
//  Move
//
//  Created by Sergiu Corbu on 16.04.2021.
//

import SwiftUI

struct HistoryView: View {
   
    let onBack: () -> Void
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            NavigationBar(title: "History", color: .darkPurple, avatar: nil, flashLight: false, backButton: "chevron-left-purple", action: {
                onBack()
            })
            TripDetail() // foreach trip in trips...
        }
        .padding([.leading, .trailing], 24)
        .background(Color.white)
    }
}

struct TripDetail: View {
    
    var body: some View {
        ZStack {
            GeometryReader { geometry in
                RoundedRectangle(cornerRadius: 29)
                    .stroke(Color.darkPurple, lineWidth: 1)
                    .overlay(
                        HStack {
                            RoundedRectangle(cornerRadius: 29)
                                .fill(Color.fadePurple)
                                .opacity(0.15)
                                .frame(width: geometry.size.width / 1.55)
                            Spacer()
                        }//.padding(.all, 0.5)
                    )
            }
            HStack {
                tripBoundaries
                Spacer()
                tripTime
            }
        }
    }
    var tripBoundaries: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                Text("From")
                    .foregroundColor(.fadePurple)
                    .font(.custom(FontManager.Primary.medium, size: 12))
                Text("9776 Gutkowski Shores Suite 420 ")
                    .foregroundColor(.darkPurple)
                    .font(.custom(FontManager.Primary.bold, size: 14))
                    .multilineTextAlignment(.leading)
                    .padding(.bottom, 1)
                    .frame(maxWidth: 180, alignment: .leading)
                    .lineLimit(2)
            }
            VStack(alignment: .leading) {
                Text("To")
                    .foregroundColor(.fadePurple)
                    .font(.custom(FontManager.Primary.medium, size: 12))
                Text("261 Howell Gardhnkjnjj jjjjjjjjjgh")
                    .foregroundColor(.darkPurple)
                    .font(.custom(FontManager.Primary.bold, size: 14))
                    .frame(maxWidth: 180, alignment: .leading)
                    .lineLimit(3)
            }.padding(.bottom, 5)
        }
        .padding(.leading, 25)
        .padding([.top, .bottom], 15)
    }
    
    var tripTime: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                Text("Travel time")
                    .foregroundColor(.fadePurple)
                    .font(.custom(FontManager.Primary.medium, size: 12))
                Text("00:42 min")
                    .foregroundColor(.darkPurple)
                    .font(.custom(FontManager.Primary.bold, size: 14))
                    .padding(.bottom, 10)
                    .frame(maxWidth: 90, alignment: .leading)
                    .lineLimit(1)
                Spacer()
            }
            VStack(alignment: .leading) {
                Text("Distance")
                    .foregroundColor(.fadePurple)
                    .font(.custom(FontManager.Primary.medium, size: 12))
                Text("7.8 km")
                    .foregroundColor(.darkPurple)
                    .font(.custom(FontManager.Primary.bold, size: 14))
                    .frame(maxWidth: 80, alignment: .leading)
                    .lineLimit(1)
                Spacer()
            }
        }
        .padding(.trailing, 10)
        .padding([.top, .bottom], 15)
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView(onBack: {})
    }
}
