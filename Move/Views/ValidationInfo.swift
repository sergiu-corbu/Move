//
//  ValidationInfo.swift
//  Move
//
//  Created by Sergiu Corbu on 14.04.2021.
//

import SwiftUI

struct ValidationInfo: View {
    
    @State private var showActionSheet: Bool = false
    
    var body: some View {
        VStack {
            HStack { //navigation bar
                Spacer()
                Text("Driving License")
                    .font(.custom(FontManager.BaiJamjuree.semiBold, size: 20))
                    .padding(.bottom, 30)
                Spacer()
            }

            GeometryReader { geometry in
                Image("driver-license-img")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: geometry.size.width, height: geometry.size.height / 1.3)
            }
            .padding(.bottom, 15)
            
            VStack {
                HStack {
                    Text("Before you can start riding")
                        .font(.custom(FontManager.BaiJamjuree.bold, size: 32))
                        .fixedSize(horizontal: false, vertical: true)
                        .padding([.bottom, .top], 10)
                    Spacer()
                }
                HStack {
                    Text("Please take a photo or upload the front side of your driving license so we can make sure that it is valid.")
                        .font(.custom(FontManager.BaiJamjuree.regular, size: 18))
                        .opacity(0.8)
                        .multilineTextAlignment(.leading)
                    Spacer()
                }
                Spacer()
                CallToActionButton(enabled: true, text: "Add driving license", action: {
                    showActionSheet.toggle()
                }).actionSheet(isPresented: $showActionSheet, content: {
                    let camera = ActionSheet.Button.default(Text("Take picture")) {
                        //open camera
                    }
                    
                    let gallery = ActionSheet.Button.default(Text("Select from gallery")) {
                        //open camera
                    }
                    
                    let cancel = ActionSheet.Button.cancel(Text("Cancel").foregroundColor(.red)) {
                        showActionSheet = false
                    }
                    
                    return ActionSheet(title: Text("Select options"), buttons: [camera, gallery, cancel])
                })
            }
            .padding([.leading, .trailing], 24)
        }
        .foregroundColor(.darkPurple)
        .background(Color.white)
    }
}

struct ValidationInfo_Previews: PreviewProvider {
    static var previews: some View {
        ValidationInfo()
    }
}
