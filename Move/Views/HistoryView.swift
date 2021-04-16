//
//  HistoryView.swift
//  Move
//
//  Created by Sergiu Corbu on 16.04.2021.
//

import SwiftUI
import NavigationStack

struct HistoryView: View {
    @ObservedObject var navigationViewModel: NavigationStack = NavigationStack()
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            NavigationBar(title: "History", avatar: nil, backButton: "chevron-left-purple", action: {
                //go back to menu page
            }).padding(.top, 50) // title as activity indicator, not moving
    
            TripDetail()
                .padding(.top, 150)
        }
        .padding([.leading, .trailing], 24)
        //.background(Color.white) // stable color or based on map?
        .edgesIgnoringSafeArea(.all)
        
    }
}

struct TripDetail: View {
    
    var body: some View {
        
        HStack {
            tripBoundaries
            Spacer()
            tripTime
        }
        .background(Image("trip-history-background")) //to do with zstack
    }
    
    var tripBoundaries: some View {
        VStack(alignment: .leading) {
            Text("From")
                .foregroundColor(.fadePurple)
                .font(.custom(FontManager.Primary.medium, size:     14))
            Text("9776 Gutkowski Shores Suite 420 ")
                .foregroundColor(.darkPurple)
                .font(.custom(FontManager.Primary.bold, size: 16))
                .multilineTextAlignment(.leading)
                .padding(.bottom, 10)
                .frame(maxWidth: 180, alignment: .leading)
                .lineLimit(3)
            Text("To")
                .foregroundColor(.fadePurple)
                .font(.custom(FontManager.Primary.medium, size:     14))
            Text("261 Howell Garden")
                .foregroundColor(.darkPurple)
                .font(.custom(FontManager.Primary.bold, size: 16))
                .frame(maxWidth: 180, alignment: .leading)
                .lineLimit(3)
        }
        .padding(.leading, 25)
    }
    
    var tripTime: some View {
        VStack(alignment: .leading) {
            Text("Travel time")
                .foregroundColor(.fadePurple)
                .font(.custom(FontManager.Primary.medium, size:     14))
            Text("00:42 min")
                .foregroundColor(.darkPurple)
                .font(.custom(FontManager.Primary.bold, size: 16))
                .padding(.bottom, 10)
                .frame(maxWidth: 90, alignment: .leading)
                .lineLimit(1)
            Text("Distance")
                .foregroundColor(.fadePurple)
                .font(.custom(FontManager.Primary.medium, size:     14))
            Text("7.8 km")
                .foregroundColor(.darkPurple)
                .font(.custom(FontManager.Primary.bold, size: 16))
                .frame(maxWidth: 80, alignment: .leading)
                .lineLimit(1)
        }
        .padding(.trailing, 10)
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
    }
}
