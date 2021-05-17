//
//  QRUnlock.swift
//  Move
//
//  Created by Sergiu Corbu on 27.04.2021.
//

import SwiftUI

struct QRUnlock: View {
    let action: () -> Void
    var body: some View {
       VStack {
            NavigationBar(title: "Scan QR", color: .white, flashLight: true, backButton: "close", action: {action()})
        }
		.background(SharedElements.purpleBackground)
    }
}

struct ScanQR_Previews: PreviewProvider {
    static var previews: some View {
        QRUnlock(action: {})
    }
}
