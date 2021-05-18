//
//  QRUnlock.swift
//  Move
//
//  Created by Sergiu Corbu on 27.04.2021.
//

import SwiftUI

struct QRUnlock: View {
    let onClose: () -> Void
	let unlockMethod: (UnlockType) -> Void
    var body: some View {
       VStack {
            NavigationBar(title: "Scan QR", color: .white, flashLight: true, backButton: "close", action: { onClose() })
        }
		.background(SharedElements.purpleBackground)
    }
}

struct ScanQR_Previews: PreviewProvider {
    static var previews: some View {
		QRUnlock(onClose: {}, unlockMethod: { _ in})
    }
}
