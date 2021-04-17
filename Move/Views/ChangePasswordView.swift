//
//  ChangePasswordView.swift
//  Move
//
//  Created by Sergiu Corbu on 17.04.2021.
//

import SwiftUI

struct ChangePasswordView: View {
    
    @State private var oldPassword: String = ""
    @State private var newPassword: String = ""
    @State private var confirmPassword: String = ""
    @State private var isLoading: Bool = false
    
    @State private var oldPasswordActive: Bool = false
    @State private var newPasswordActive: Bool = false
    @State private var confirmPasswordActive: Bool = false
    
    var allFiledsCompleted: Bool {
        return oldPassword != "" && newPassword != "" && confirmPassword != ""
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            NavigationBar(title: "Change password", avatar: nil, backButton: "chevron-left-purple", action: {})
                .padding(.top, 60)
            inputArea
            Spacer()
            CallToActionButton(isLoading: isLoading, enabled: allFiledsCompleted, text: "Save edits", action: {
                isLoading = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                    isLoading = false
                })
                // update password
            }).padding(.bottom, 30)
        }
        .padding([.leading, .trailing], 24)
        .edgesIgnoringSafeArea(.all)
        .background(Color.white)
                
    }
    
    var inputArea: some View {
        
        VStack(alignment: .leading, spacing: 20) {
            InputField(activeField: $oldPasswordActive, input: $oldPassword, textField: "Old password", image: "", isSecuredField: false, textColor: Color.darkPurple, action: {
                oldPasswordActive = true
                newPasswordActive = false
                confirmPasswordActive = false
            })
            InputField(activeField: $newPasswordActive, input: $newPassword, textField: "New password", image: "", isSecuredField: false, textColor: Color.darkPurple, action: {
                oldPasswordActive = false
                newPasswordActive = true
                confirmPasswordActive = false
            })
            InputField(activeField: $confirmPasswordActive, input: $confirmPassword, textField: "Confirm new password", image: "eye-off-img", isSecuredField: true, textColor: Color.darkPurple, action: {
                oldPasswordActive = false
                newPasswordActive = false
                confirmPasswordActive = true
            })
        }.padding(.top, 50)
    }
}

struct ChangePasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ChangePasswordView()
            .preferredColorScheme(.light)
    }
}
