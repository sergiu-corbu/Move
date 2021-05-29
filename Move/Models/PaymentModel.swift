//
//  PaymentModel.swift
//  Move
//
//  Created by Sergiu Corbu on 13.05.2021.
//

import Foundation
import PassKit

typealias PaymentCompletionHandler = (Bool) -> Void

class Payment: NSObject {
	
	static let supportedNetworks: [PKPaymentNetwork] = [.amex, .masterCard, .visa]
	
	var paymentController: PKPaymentAuthorizationController?
	var paymentSummaryItems = [PKPaymentSummaryItem]()
	var paymentStatus = PKPaymentAuthorizationStatus.failure
	var completionHandler: PaymentCompletionHandler?
	
	func startPayment(price: String, completion: @escaping PaymentCompletionHandler) {
		
		//        let amount = PKPaymentSummaryItem(label: "Amount", amount: NSDecimalNumber(string: "8.88"), type: .final)
		//        let tax = PKPaymentSummaryItem(label: "Tax", amount: NSDecimalNumber(string: "1.12"), type: .final)
		let total = PKPaymentSummaryItem(label: "Total", amount: NSDecimalNumber(string: price), type: .final)
		
		//        paymentSummaryItems = [amount, tax, total];
		paymentSummaryItems = [total];
		completionHandler = completion
		
		// Create our payment request
		let paymentRequest = PKPaymentRequest()
		paymentRequest.paymentSummaryItems = paymentSummaryItems
		paymentRequest.merchantIdentifier = "merchant.com.TAPPTITUDE.MOVE"
		paymentRequest.merchantCapabilities = .capability3DS
		paymentRequest.countryCode = "RO"
		paymentRequest.currencyCode = "RON"
		paymentRequest.requiredShippingContactFields = [.phoneNumber, .emailAddress]
		paymentRequest.supportedNetworks = Payment.supportedNetworks
		
		// Display our payment request
		paymentController = PKPaymentAuthorizationController(paymentRequest: paymentRequest)
		paymentController?.delegate = self
		paymentController?.present(completion: { (presented: Bool) in
			if presented {
				NSLog("Presented payment controller")
			} else {
				NSLog("Failed to present payment controller")
				self.completionHandler!(false)
			}
		})
	}
}

/*
PKPaymentAuthorizationControllerDelegate conformance.
*/
extension Payment: PKPaymentAuthorizationControllerDelegate {
	
	func paymentAuthorizationController(_ controller: PKPaymentAuthorizationController, didAuthorizePayment payment: PKPayment, completion: @escaping (PKPaymentAuthorizationStatus) -> Void) {
		
		// Perform some very basic validation on the provided contact information
		if payment.shippingContact?.emailAddress == nil || payment.shippingContact?.phoneNumber == nil {
			paymentStatus = .failure
		} else {
			// Here you would send the payment token to your server or payment provider to process
			// Once processed, return an appropriate status in the completion handler (success, failure, etc)
			paymentStatus = .success
		}
		
		completion(paymentStatus)
	}
	
	func paymentAuthorizationControllerDidFinish(_ controller: PKPaymentAuthorizationController) {
		controller.dismiss {
			DispatchQueue.main.async {
				if self.paymentStatus == .success {
					self.completionHandler!(true)
				} else {
					self.completionHandler!(false)
				}
			}
		}
	}
	
}

//typealias PaymentHandler = (Bool) -> Void
//
//class Payment: NSObject {
//	static let paymentNetworks: [PKPaymentNetwork] = [.masterCard, .visa, .amex]
//	var paymentController: PKPaymentAuthorizationController?
//	var paymentItems = [PKPaymentSummaryItem]()
//	var paymentStatus = PKPaymentAuthorizationStatus.failure
//	var totalPrice: Double
//	var callback: PaymentHandler?
//
//	init(totalPrice: Double) {
//		self.totalPrice = totalPrice
//	}
//
//	func startPayment(completion: @escaping PaymentHandler) {
//		let ammount = PKPaymentSummaryItem(label: "TOTAL", amount: 0.0)
//
//		paymentItems = [ammount]
//		callback = completion
//
//		let paymentRequest = PKPaymentRequest()
//		paymentRequest.paymentSummaryItems = paymentItems
//		paymentRequest.merchantIdentifier = "moove.com.payment"
//		paymentRequest.merchantCapabilities = [.capability3DS, .capabilityCredit, .capabilityDebit]
//		paymentRequest.countryCode = "RO"
//		paymentRequest.currencyCode = "RON"
////		paymentRequest.requiredShippingContactFields = [.emailAddress, .name]
//		paymentRequest.requiredBillingContactFields = [.emailAddress, .name]
//		paymentRequest.supportedNetworks = Payment.paymentNetworks
//
//		paymentController = PKPaymentAuthorizationController(paymentRequest: paymentRequest)
//		paymentController?.delegate = self
//		paymentController?.present(completion: { (isPresented: Bool) in
//			if isPresented { print("")}
//			else { print("Failed"); self.callback!(false)}
//		})
//	}
//}
//
//extension Payment: PKPaymentAuthorizationControllerDelegate {
//
//	func paymentAuthorizationController(_ controller: PKPaymentAuthorizationController, didAuthorizePayment payment: PKPayment, completion: @escaping (PKPaymentAuthorizationStatus) -> Void) {
//		if payment.shippingContact?.emailAddress == nil || payment.shippingContact?.name == nil {
//			paymentStatus = .failure
//		} else {
//			paymentStatus = .success
//		}
//		completion(paymentStatus)
//	}
//
//	func paymentAuthorizationControllerDidFinish(_ controller: PKPaymentAuthorizationController) {
//		controller.dismiss {
//			DispatchQueue.main.async {
//				if self.paymentStatus == .success {
//					self.callback!(true)
//				} else {
//					self.callback!(false)
//				}
//			}
//		}
//	}
//
//}
