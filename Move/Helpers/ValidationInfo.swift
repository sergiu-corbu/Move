//
//  ValidationInfo.swift
//  Move
//
//  Created by Sergiu Corbu on 14.04.2021.
//

import SwiftUI

struct ValidationInfo: View {
    
    @State var image: Image?
    @State private var showActionSheet: Bool = false
    @State private var showImagePicker: Bool = false
    @State private var showCamera: Bool = false
    @StateObject var statusBarConfigurator = StatusBarConfigurator()
    @Binding var isLoading: Bool
    
    let onBack: () -> Void
    let onNext: (Image) -> Void
    
    var body: some View {
        VStack(spacing: 35) {
            NavigationBar(title: "Driver License", avatar: nil, backButton: "chevron-left-purple", action: {
                onBack()
            }) .padding([.leading, .trailing], 24)
                .padding(.top, 50)
                .padding(.bottom, -30)
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
                CallToActionButton(isLoading: isLoading, enabled: true, text: "Add drivig license", action: {
                    showActionSheet.toggle()
                }).padding(.bottom)
                .sheet(isPresented: $showImagePicker) {
                    ImagePickerView(sourceType: showCamera ? .camera : .photoLibrary, image: imageBinding, isPresented: $showImagePicker)
                }
                .actionSheet(isPresented: $showActionSheet, content: {
                    let camera = ActionSheet.Button.default(Text("Take picture")) {
                        showImagePicker = true
                        showCamera = true
                        showActionSheet = false
                    }
                    
                    let gallery = ActionSheet.Button.default(Text("Select from gallery")) {
                        showImagePicker = true
                        showCamera = false
                        showActionSheet = false
                    }
                    
                    let cancel = ActionSheet.Button.cancel(Text("Cancel").foregroundColor(.red)) {
                        showActionSheet = false
                        showImagePicker = false
                        showCamera = false
                    }
                    return ActionSheet(title: Text("Select options"), buttons: [camera, gallery, cancel])
                })
            }
            .padding([.leading, .trailing], 24)
        }
        .foregroundColor(.darkPurple)
        .background(Color.white)
        .edgesIgnoringSafeArea(.all)
        .prepareStatusBarConfigurator(statusBarConfigurator)
        .onAppear{
            statusBarConfigurator.statusBarStyle = .darkContent
        }
    }
    var imageBinding: Binding<Image?> {
        return Binding(get: {
            return Image("")
        }, set: { image in
            if let _image = image {
                onNext(_image)
            }
        })
    }
}

extension ValidationInfo {
    func goToDeviceSettings() {
        guard let url = URL.init(string: UIApplication.openSettingsURLString) else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}

struct ValidationInfo_Previews: PreviewProvider {
    static var previews: some View {
        ValidationInfo(isLoading: .constant(true), onBack: {}, onNext: {_ in})
    }
}
