//
//  SessionValidator.swift
//  Move
//
//  Created by Sergiu Corbu on 13.04.2021.
//

import Foundation

class Session: ObservableObject {
	
	static var shared = Session()
    
	private init() {
		
	}
	
	static var tokenKey: String? {
        get {
			return UserDefaults.standard.string(forKey: "tokenKey")
		}
		set {
			UserDefaults.standard.setValue(newValue, forKey: "tokenKey")
		}
    }
	
	static var username: String? {
		get {
			return UserDefaults.standard.string(forKey: "username")
		}
		set {
			UserDefaults.standard.setValue(newValue, forKey: "username")
		}
	}
	
	static var licenseVerified: Bool = true
	static var ongoingTrip: Bool = false
	
	var suspendUser: Bool = false {
		didSet {
			self.objectWillChange.send()
		}
	}
}
