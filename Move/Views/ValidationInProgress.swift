//
//  ValidationInProgress.swift
//  Move
//
//  Created by Sergiu Corbu on 13.04.2021.
//

import SwiftUI

struct ValidationInProgress: View {
    
    var body: some View {
        VStack {
            Spacer()
            mainText
            secondaryText
            Spacer()
            exploreButton
        }
        .multilineTextAlignment(.center)
        .padding([.leading, .trailing], 24)
        .background(
            Image("rect-background-img")
                .resizable()
                .aspectRatio(contentMode: .fill)
        )
        .edgesIgnoringSafeArea(.all)
        
    }
   
    var mainText: some View {
        HStack{
            Spacer()
            Text("We are currently verifying your driving license")
                .foregroundColor(.white)
                .font(.custom(FontManager.BaiJamjuree.bold, size: 34.0))
            Spacer()
        }
        .padding(.bottom, 30)
    }
    
    var secondaryText: some View {
        HStack {
            Spacer()
            Text("Check back shortly and if everything\n looks good you’ll be riding our scooters in no time.")
                .foregroundColor(.fadePurple)
                .font(.custom(FontManager.BaiJamjuree.medium, size: 18.0))
                .lineSpacing(5)
            Spacer()
        }
    }
    
    var exploreButton: some View {
        CallToActionButton(enabled: true, text: "Explore the app", action: {
            
        })
    }
}

struct ValidationInProgress_Previews: PreviewProvider {
    static var previews: some View {
        ValidationInProgress()
    }
}
