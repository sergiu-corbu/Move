//
//  NavigationPaths.swift
//  Move
//
//  Created by Sergiu Corbu on 22.05.2021.
//

import Foundation

enum MenuNavigation {
	case goBack
	case goToHistory
	case goToAccount
	case goToChangePassword
	case logoutUser
}

enum AuthNavigation {
	case back
	case onboardingFinished
	case switchToRegister
	case switchToLogin
	case registerCompleted
	case loginCompleted
	case imageUploadCompleted
	case openMap
}

enum UnlockType {
	case code
	case qr
	case nfc
}
