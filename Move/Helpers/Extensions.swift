//
//  Fonts&Colors.swift
//  Move
//
//  Created by Sergiu Corbu on 4/11/21.
//

import Foundation
import SwiftUI

//MARK: Data validation
extension String {
	func emailValidation() -> Bool {
		let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
		return NSPredicate(format: "SELF MATCHES[c] %@", emailRegex).evaluate(with: self)
	}
	func passwordValidation() -> Bool {
		let passwordRegex = "^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])[0-9a-zA-Z!@#$%^&*()\\-_=+{}|?>.<]{6,}$"
		return NSPredicate(format:"SELF MATCHES %@", passwordRegex).evaluate(with: self)
	}
	func isUpperCase() -> Bool {
		let uppercaseReqRegex = ".*[A-Z]+.*"
		return NSPredicate(format:"SELF MATCHES %@", uppercaseReqRegex).evaluate(with: self)
	}
	func isLowerCase() -> Bool {
		let lowercaseReqRegex = ".*[a-z]+.*"
		return NSPredicate(format:"SELF MATCHES %@", lowercaseReqRegex).evaluate(with: self)
	}
	func containsCharacter() -> Bool {
		let characterReqRegex = ".*[!@#$%^&*()\\-_=+{}|?>.<]+.*"
		return NSPredicate(format:"SELF MATCHES %@", characterReqRegex).evaluate(with: self)
	}
	func containsDigit() -> Bool {
		let digitReqRegex = ".*[0-9]+.*"
		return NSPredicate(format:"SELF MATCHES %@", digitReqRegex).evaluate(with: self)
	}
}

//MARK: fonts & colors
extension Color {
    static let coralRed = Color("coralRed")
    static let darkPurple = Color("darkPurple")
    static let lightPurple = Color("lightPurple")
    static let fadePurple2 = Color("fadePurple2")
    static let fadePurple = Color("fadePurple")
    static let lightGray = Color("lightGray")
    static let lightPink = Color("lightPink")
    static let errorRed = Color("errorRed")
}

struct FontManager {
    struct Primary {
        static let regular = "BaiJamjuree-Regular"
        static let bold = "BaiJamjuree-Bold"
        static let semiBold = "BaiJamjuree-SemiBold"
        static let medium = "BaiJamjuree-Medium"
    }
}

//MARK: Rounded corners
struct RoundedCorner: Shape {
	var radius: CGFloat = .infinity
	var corners: UIRectCorner = .allCorners
	func path(in rect: CGRect) -> Path{
		let path = UIBezierPath(roundedRect: rect,byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
		return Path(path.cgPath)
	}
}

extension View{
	func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
		clipShape(RoundedCorner(radius: radius, corners: corners))
	}
}
