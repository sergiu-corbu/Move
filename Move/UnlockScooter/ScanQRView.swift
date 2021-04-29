//
//  ScanQRView.swift
//  Move
//
//  Created by Sergiu Corbu on 27.04.2021.
//

import SwiftUI

struct ScanQRView: View {
    let action: () -> Void
    var body: some View {
       VStack {
            NavigationBar(title: "Scan QR", color: .white, avatar: nil, flashLight: true, backButton: "close", action: {action()})
        }
		.background(RegisterElements.purpleBackground)
    }
}

struct ScanQRView_Previews: PreviewProvider {
    static var previews: some View {
        ScanQRView(action: {})
    }
}
