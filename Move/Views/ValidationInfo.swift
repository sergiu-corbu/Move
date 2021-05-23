//
//  ValidationInfo.swift
//  Move
//
//  Created by Sergiu Corbu on 14.04.2021.
//

import SwiftUI

struct ValidationInfo: View {
	
	@StateObject var userViewModel: UserViewModel = UserViewModel()
    @State private var showActionSheet: Bool = false
    @State private var showImagePicker: Bool = false
    @State private var showCamera: Bool = false
	@State private var showAlert = false

	let authNavigation: (AuthNavigation) -> Void
    
    var body: some View {
		GeometryReader { geometry in
			VStack(spacing: 35) {
				NavigationBar(title: "Driver License", color: .darkPurple, backButton: "chevron-left-purple", action: {
					authNavigation(.back)
				})
				.padding(.horizontal, 24)
				Image("driver-license-img")
					.resizable()
					.frame(width: geometry.size.width, height: geometry.size.height * 0.4)
					.aspectRatio(contentMode: .fill)
				VStack(alignment: .leading) {
					UnlockScooterComponents.Title(title: "Before you can start\nriding", purpleColor: true, customPadding: true, customAlignment: true)
					UnlockScooterComponents.SubTitle(subTitle: "Please take a photo or upload the front side of your driving license so we can make sure that it is valid.", purpleColor: true, customAlignment: true,  customOpacity: true)
					Spacer()
					Buttons.PrimaryButton(text: "Add drivig license", isLoading: userViewModel.isLoading, enabled: true, action: { showActionSheet.toggle() })
						.sheet(isPresented: $showImagePicker) {
							ImagePickerController(sourceType: showCamera ? .camera : .photoLibrary, image: imageBinding, isPresented: $showImagePicker)
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
								showAlert = true
							}
							return ActionSheet(title: Text("Select options"), buttons: [camera, gallery, cancel])
						})
				}
				.padding(.horizontal, 24)
			}
			.background(SharedElements.whiteBackground)
			.alert(isPresented: $showAlert) {
				Alert.init(title: Text("Enable camera usage"), primaryButton: .default(Text("Go to Settings"), action: {
					UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
				}), secondaryButton: .default(Text("Cancel"), action: { showAlert = false }))
			}
		}
    }
	
    var imageBinding: Binding<Image?> {
        return Binding(get: {
			return Image("")
		}, set: { image in
            if let image = image {
				userViewModel.isLoading = true
				userViewModel.uploadImage(image: image) {
					authNavigation(.imageUploadCompleted)
					self.userViewModel.isLoading = false
				}
			}
        })
    }
}
