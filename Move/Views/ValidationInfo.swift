//
//  ValidationInfo.swift
//  Move
//
//  Created by Sergiu Corbu on 14.04.2021.
//

import SwiftUI
import NavigationStack

struct ValidationInfo: View {
    
    @State private var showActionSheet: Bool = false
    @ObservedObject var navigationViewModel: NavigationStack = NavigationStack()
    
    let onBack: ()
    
    var body: some View {
        VStack(spacing: 35) {
            NavigationBar(title: "Driver License", backButton: "chevron-left-purple", action: {})
            GeometryReader { geometry in
                Image("driver-license-img")
                    .resizable()
                    .frame(width: geometry.size.width, height: geometry.size.height / 0.9)
                    .aspectRatio(contentMode: .fill)
            }
            VStack(alignment: .leading) {
                    Text("Before you can start riding")
                        .font(.custom(FontManager.Primary.bold, size: 32))
                        .fixedSize(horizontal: false, vertical: true)
                        .padding([.bottom, .top], 10)
                    Text("Please take a photo or upload the front side of your driving license so we can make sure that it is valid.")
                        .font(.custom(FontManager.Primary.regular, size: 17))
                        .opacity(0.8)
                        .multilineTextAlignment(.leading)
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
        ValidationInfo(onBack: ())
    }
}
