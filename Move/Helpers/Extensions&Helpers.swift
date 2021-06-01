//
//  Extensions&Helpers.swift
//  Move
//
//  Created by Sergiu Corbu on 4/11/21.
//

import Foundation
import SwiftUI
import SwiftMessages
import MapKit
import CoreLocation
import NavigationStack

//MARK: helper functions
func unwrapScooter(scooter: Scooter?, _ callback: @escaping (Scooter) -> Void) {
	guard let scooter = scooter else {
		showError(error: "No scooter selected")
		return
	}
	callback(scooter)
}

func formatTime(string: String) -> String {
	let time: String.SubSequence = string.suffix(5)
	return String(time)
}

func streetGeocode(coordinates: [Double], _ completion: @escaping (String) -> Void) {
	let geocoder = CLGeocoder()
	let locationCoord: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: coordinates[0], longitude: coordinates[1])
	let location = CLLocation(latitude: locationCoord.latitude, longitude: locationCoord.longitude)
	
	geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
		guard let placemark = placemarks?.first else {
			showError(error: "could not reverse geocode")
			return
		}
		let streetName: String = placemark.thoroughfare ?? ""
		let streetNumber: String = placemark.subThoroughfare ?? ""
		let result = streetName + " " + streetNumber
		completion(result)
	}
}

func convertTime(time: Int) -> String {
	return String(format: "%02d:%02d", time / 60, time % 60)
}

//MARK: MapDefaultRegion
extension MKCoordinateRegion {
	static var defaultRegion: MKCoordinateRegion {
		MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 46.753498, longitude: 23.59), latitudinalMeters: 2000, longitudinalMeters: 2000)
	}
}

//MARK: SwiftMessages
public func showError(error: String) {
	let view = MessageView.viewFromNib(layout: .messageView, bundle: Bundle.main)
	view.configureTheme(.error)
	view.configureDropShadow()
	view.configureContent(title: "Error", body: error, iconImage: nil, iconText: nil, buttonImage: nil, buttonTitle: nil) { _ in }
	view.layoutMarginAdditions = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
	(view.backgroundView as? CornerRoundingView)?.cornerRadius = 10
	SwiftMessages.show(view: view)
}

public func showMessage(message: String) {
	let view = MessageView.viewFromNib(layout: .messageView, bundle: Bundle.main)
	view.configureTheme(.success)
	view.configureDropShadow()
	view.configureContent(title: message, body: nil, iconImage: nil, iconText: nil, buttonImage: nil, buttonTitle: nil) { _ in }
	view.layoutMarginAdditions = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
	(view.backgroundView as? CornerRoundingView)?.cornerRadius = 10
	SwiftMessages.show(view: view)
}

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

extension Font {
	static var bayJ24: Font {
		Font.custom("BaiJamjuree-SemiBold", size: 24)
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
	func hideKeyboard() {
		UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
	}
}


//MARK: Onboarding data

struct OnboardingData {
	let title: String
	let description: String
	let image: String
}

let onboardingData = [
	OnboardingData(title: "Safety", description: "Please wear a helmet and protect yourself while riding.", image: "Safety-img"),
	OnboardingData(title: "Scan", description: "Scan the QR code or NFC sticker on top of the scooter to unlock and ride.", image: "Scan-img"),
	OnboardingData(title: "Ride", description: "Step on the scooter with one foot and kick off the ground. When the scooter starts to coast, push the right throttle to accelerate.", image: "Ride-img"),
	OnboardingData(title: "Parking", description: "If convenient, park at a bike rack. If not, park close to the edge of the sidewalk closest to the street. Do not block sidewalks, doors or ramps.", image: "Parking-img"),
	OnboardingData(title: "Rules", description: "You must be 18 years or older with a valid driving licence to perate a scooter. Please follow all street signs, signals, markings and obey local traffic laws.", image: "Rules-img")
]
