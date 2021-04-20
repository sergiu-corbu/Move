//
//  Fonts&Colors.swift
//  Move
//
//  Created by Sergiu Corbu on 4/11/21.
//

import Foundation
import SwiftUI

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


extension Double{
    var clean: String{
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%..0f", self) : String(self)
    }
}
