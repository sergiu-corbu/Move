//
//  Reusable Buttons.swift
//  Move
//
//  Created by Sergiu Corbu on 4/11/21.
//

import SwiftUI

struct ReusableButton: View {
    let text: String
    var body: some View {
        HStack {
            Button(action: {
                
            }, label: {
                Spacer()
                Text(text)
                    .foregroundColor(.white)
                    .font(Font.custom(FontManager.BaiJamjuree.bold, size: 16))
                Spacer()
            })
            .padding(.all, 20)
            .background(RoundedRectangle(cornerRadius: 16.0)
                            .strokeBorder(Color.coralRed, lineWidth: 1)
                            .background(RoundedRectangle(cornerRadius: 16.0).fill(Color.coralRed))
                            .opacity(1)
                        
            )
        }
        .padding([.top, .bottom], 20)
    }
}
