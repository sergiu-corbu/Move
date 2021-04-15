//
//  UIModifiers.swift
//  Move
//
//  Created by Sergiu Corbu on 13.04.2021.
//

import Foundation
import SwiftUI
import UIKit


extension Text: ViewModifier {
    func agreementModifiers() {
        self
            .foregroundColor(.white)
            .font(.custom(FontManager.Primary.semiBold, size: 14))
            .bold()
            .underline()
    }
}
