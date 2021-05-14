//
//  PaymentModel.swift
//  Move
//
//  Created by Sergiu Corbu on 13.05.2021.
//

import Foundation
import PassKit

typealias PaymentHandler = (Bool) -> Void

class Payment: NSObject {
	static let paymentNetworks: [PKPaymentNetwork] = [.masterCard, .visa, .amex]
	
	var paymentController: PKPaymentAuthorizationController?
	var paymentItems = [PKPaymentSummaryItem]()
	var paymentStatus = PKPaymentAuthorizationStatus.failure
	var callback: PaymentHandler?
	
	func startPayment(completion: @escaping PaymentHandler) {
		let ammount = PKPaymentSummaryItem(label: "TOTAL", amount: 34)
		
		paymentItems = [ammount]
		callback = completion
		
		let paymentRequest = PKPaymentRequest()
		paymentRequest.paymentSummaryItems = paymentItems
		paymentRequest.merchantIdentifier = "moove.com.payment"
		paymentRequest.merchantCapabilities = [.capability3DS, .capabilityCredit, .capabilityDebit]
		paymentRequest.countryCode = "RO"
		paymentRequest.currencyCode = "RON"
//		paymentRequest.requiredShippingContactFields = [.emailAddress, .name]
		paymentRequest.requiredBillingContactFields = [.emailAddress, .name]
		paymentRequest.supportedNetworks = Payment.paymentNetworks
		
		paymentController = PKPaymentAuthorizationController(paymentRequest: paymentRequest)
		paymentController?.delegate = self
		paymentController?.present(completion: { (isPresented: Bool) in
			if isPresented { print("")}
			else { print("Failed"); self.callback!(false)}
		})
		
	}
}

extension Payment: PKPaymentAuthorizationControllerDelegate {
	func paymentAuthorizationController(_ controller: PKPaymentAuthorizationController, didAuthorizePayment payment: PKPayment, completion: @escaping (PKPaymentAuthorizationStatus) -> Void) {
		
		if payment.shippingContact?.emailAddress == nil || payment.shippingContact?.name == nil {
			paymentStatus = .failure
		} else {
			paymentStatus = .success
		}
		completion(paymentStatus)
	}
	
	func paymentAuthorizationControllerDidFinish(_ controller: PKPaymentAuthorizationController) {
		controller.dismiss {
			DispatchQueue.main.async {
				if self.paymentStatus == .success {
					self.callback!(true)
				} else {
					self.callback!(false)
				}
			}
		}
	}
	
}
