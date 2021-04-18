//
//  SessionValidator.swift
//  Move
//
//  Created by Sergiu Corbu on 13.04.2021.
//

import Foundation

struct Session {
    static var tokenKey: String? {
        get {
            return UserDefaults.standard.string(forKey: "tokenKey")
        } set {
            UserDefaults.standard.setValue(newValue, forKey: "tokenKey")
        }
    }
}

