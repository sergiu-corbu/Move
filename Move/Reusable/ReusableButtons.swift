//
//  Reusable Buttons.swift
//  Move
//
//  Created by Sergiu Corbu on 4/11/21.
//

import SwiftUI

struct ReusableButton: View {
    @Binding var activeField: Bool
    let text: String
    let action: () -> Void

    var body: some View {
        HStack {
            Button(action: {
                action()
            }, label: {
                Spacer()
                Text(text)
                    .foregroundColor(activeField ? .white : .fadePurple)
                    .font(activeField ? Font.custom(FontManager.BaiJamjuree.bold, size: 16)  : Font.custom(FontManager.BaiJamjuree.medium, size: 16))
                Spacer()
            })
            .padding(.all, 20)
            .background(RoundedRectangle(cornerRadius: 16.0)
                            .strokeBorder(Color.coralRed, lineWidth: 1)
                            .background(RoundedRectangle(cornerRadius: 16.0).fill(activeField ? Color.coralRed : Color.clear))
                            .opacity(activeField ? 1 : 0.3)
                        
            )
            .disabled(!activeField)
        }
        .padding([.top, .bottom], 20)
    }
}
struct AuthButton: View {
    
    let enabled: Bool
    let text: String
    var body: some View {
        HStack{
            Spacer()
            Text(text)
                .foregroundColor(enabled ? .white : .fadePurple)
                .font(enabled ? Font.custom(FontManager.BaiJamjuree.bold, size: 16)  : Font.custom(FontManager.BaiJamjuree.medium, size: 16))
            Spacer()
        }
        .padding(.all, 20)
        .background(RoundedRectangle(cornerRadius: 16.0)
                        .strokeBorder(Color.coralRed, lineWidth: 1)
                        .background(RoundedRectangle(cornerRadius: 16.0).fill(enabled ? Color.coralRed : Color.clear))
                        .opacity(enabled ? 1 : 0.3)
                    
        )
        .disabled(!enabled)
    }
}
