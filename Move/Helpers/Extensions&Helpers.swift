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

//MARK: MapDefaultRegion
extension MKCoordinateRegion {
	static var defaultRegion: MKCoordinateRegion {
		MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 46.753498, longitude: 23.59), latitudinalMeters: 4000, longitudinalMeters: 4000)
	}
}

//MARK: swiftui view to UIView

extension View {
	func uiImage() -> UIImage {
		let controller = UIHostingController(rootView: self)
		controller.view.frame = CGRect(x: 0, y: CGFloat(Int.max), width: 1, height: 1)
		UIApplication.shared.windows.first!.rootViewController?.view.addSubview(controller.view)
		let size = controller.sizeThatFits(in: UIScreen.main.bounds.size)
		controller.view.bounds = CGRect(origin: .zero, size: size)
		controller.view.sizeToFit()
		
		let image = controller.view.uiImage()
		controller.view.removeFromSuperview()
		return image
	}
}



//MARK: UIView to UIImage
extension UIView {
	func uiImage() -> UIImage {
		let renderer = UIGraphicsImageRenderer(bounds: bounds)
		return renderer.image { rendererContext in
			layer.render(in: rendererContext.cgContext)
		}
	}
}

//MARK: UnlockType

enum UnlockType {
	case code
	case qr
	case nfc
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
