//
//  Api.swift
//  Move
//
//  Created by Sergiu Corbu on 12.04.2021.
//

import Foundation
import Alamofire
import SwiftUI

typealias Result<T> = Swift.Result<T, APIError>
typealias GetScooter = [String : Scooter]
class API {
	
	static let baseUrl: String = "https://move-tapp.herokuapp.com/api/"
	
	static func requestBody(_ callback: @escaping (HTTPHeaders) -> Void) {
		guard let token = Session.tokenKey else {
			return
		}
		let header: HTTPHeaders = ["Authorization": "Bearer \(token)"]
		callback(header)
	}
	
	static func handleResponse<T: Decodable>(response: AFDataResponse<Data>) -> Result<T> {
		do {
			if response.response?.statusCode == 200 {
				let result = try JSONDecoder().decode(T.self, from: response.data!)
				return .success(result)
			} else if response.response?.statusCode == 401 {
				Session.tokenKey = nil
				Session.shared.suspendUser = true
				guard let result = response.data else { return .failure(APIError(message: "network error")) }
				let result1 = try JSONDecoder().decode(APIError.self, from: result)
				return .failure(APIError(message: result1.message))
			} else {
				guard let result = response.data else { return .failure(APIError(message: "network error")) }
				let result1 = try JSONDecoder().decode(APIError.self, from: result)
				return .failure(APIError(message: result1.localizedDescription))
			}
		} catch DecodingError.keyNotFound(let key, let context) {
			print("could not find key \(key) in JSON: \(context.debugDescription)")
		} catch DecodingError.valueNotFound(let type, let context) {
			print("could not find type \(type) in JSON: \(context.debugDescription)")
		} catch DecodingError.typeMismatch(let type, let context) {
			print("type mismatch for type \(type) in JSON: \(context.debugDescription)")
		} catch DecodingError.dataCorrupted(let context) {
			print("data found to be corrupted in JSON: \(context.debugDescription)")
		} catch let error as NSError {
			NSLog("Error in read(from:ofType:) domain= \(error.domain), description= \(error.localizedDescription)")
		}
		return .failure(APIError(message: "not correct format"))
	}
	
	//MARK: User
	static func registerUser(email: String, password: String, username: String, _ callback: @escaping (Result<AuthResult>) -> Void) {
		let path = baseUrl + "auth/register"
		let parameters = ["email": email, "username": username, "password": password]
		AF.request(path, method: .post, parameters: parameters, encoder: JSONParameterEncoder.default).validate().responseData { response in
			let result: Result<AuthResult> = handleResponse(response: response)
			callback(result)
		}
	}

	static func loginUser(email: String, password: String, _ callback: @escaping (Result<AuthResult>) -> Void) {
		let path = baseUrl + "auth/login"
		let parameters = ["email": email, "password": password]
		AF.request(path, method: .post, parameters: parameters, encoder: JSONParameterEncoder.default).validate().responseData { response in
			let result: Result<AuthResult> = handleResponse(response: response)
			callback(result)
		}
	}

	static func resetPassword(oldPassword: String, newPassword: String, _ callback: @escaping (Bool) -> Void) {
		let path = baseUrl + "auth/password"
		let parameters = ["oldPassword": oldPassword, "newPassword": newPassword]
		requestBody { header in
			AF.request(path, method: .put, parameters: parameters, encoder: JSONParameterEncoder.default, headers: header).validate().responseData { response in
				if response.response?.statusCode == 200 {
					callback(true)
				} else {
					callback(false)
				}
			}
		}
	}

	static func logout(_ callback: @escaping (Bool) -> Void) {
		requestBody { header in
			let path = baseUrl + "auth/logout"
			AF.request(path, method: .delete, headers: header).validate().responseData { response in
				if response.response?.statusCode == 200 {
					callback(true)
				} else {
					callback(false)
				}
			}
		}
	}
	
	//MARK: Scooter
	static func getScooters(coordinates: [Double], _ callback: @escaping (Result<Scooters>) -> Void) {
		requestBody { header in
			let path = baseUrl + "scooters?lat=\(coordinates[0])&long=\(coordinates[1])"
			AF.request(path, headers: header).validate().responseData { response in
				let result: Result<Scooters> = handleResponse(response: response)
				callback(result)
			}
		}
	}
	
	static func getCurrentScooter(scooterId: String, _ callback: @escaping (Result<GetSooter>) -> Void) {
		requestBody { header in
			let path = baseUrl + "scooters/\(scooterId)"
			AF.request(path, method: .get, headers: header).validate().responseData { response in
				let result: Result<GetSooter> = handleResponse(response: response)
				callback(result)
			}
		}
	}
	
	static func unlockScooterPin(code: String, street: String, location: [Double], _ callback: @escaping (Result<StartTrip>) -> Void) {
		requestBody { header in
			let path = baseUrl + "bookings?lat=\(location[0])&long=\(location[1])"
			let parameters: [String:String] = ["address": street, "scooterNumber": code]
			AF.request(path, method: .post, parameters: parameters, encoder: JSONParameterEncoder.default, headers: header).validate().responseData { response in
				let result: Result<StartTrip> = handleResponse(response: response)
				callback(result)
			}
		}
	}
	static func unlockScooterQR(code: String, street: String, _ callback: @escaping (Result<StartTrip>) -> Void) {
		requestBody { header in
			let path = baseUrl + "bookings?fromQr=true"
			let parameters: [String:String] = ["address": street, "scooterNumber": code]
			AF.request(path, method: .post, parameters: parameters, encoder: JSONParameterEncoder.default, headers: header).validate().responseData { response in
				let result: Result<StartTrip> = handleResponse(response: response)
				callback(result)
			}
		}
	}
	
	static func unlockScooterNFC(code: String, street: String, _ callback: @escaping (Result<StartTrip>) -> Void) {
		requestBody { header in
			let path = baseUrl + "bookings?fromNfc=true"
			let parameters: [String:String] = ["address": street, "scooterNumber": code]
			AF.request(path, method: .post, parameters: parameters, encoder: JSONParameterEncoder.default, headers: header).validate().responseData { response in
				let result: Result<StartTrip> = handleResponse(response: response)
				callback(result)
			}
		}
	}
	
	static func pingScooter(scooterKey: String, location: [Double], _ callback: @escaping (Result<Ping>) -> Void) {
		requestBody { header in
			let path = baseUrl + "scooters/ping/\(scooterKey)/?lat=\(location[0])&long=\(location[1])"
			AF.request(path, method: .get, headers: header).validate().responseData { response in
				let result: Result<Ping> = handleResponse(response: response)
				callback(result)
			}
		}
	}

	static func downloadTripHistory(pageSize: Int, _ callback: @escaping (Result<TripsHistory>) -> Void) {
		requestBody { header in
			let path = baseUrl + "bookings/?start=0&length=20"
			AF.request(path, method: .get, headers: header).validate().responseData { response in
				let result: Result<TripsHistory> = handleResponse(response: response)
				callback(result)
			}
		}
	}
	
	static func lockUnlock(bookingId: String, _ callback: @escaping (Result<LockUnlockResult>) -> Void){
		requestBody { header in
			let path = baseUrl + "bookings/\(bookingId)/lock"
			AF.request(path, method: .put, headers: header).validate().responseData { response in
				let result: Result<LockUnlockResult> = handleResponse(response: response)
				callback(result)
			}
		}
	}
	
	static func endTrip(scooterID: String, coordinates: [Double], endStreet: String, _ callback: @escaping (Result<EndTrip>) -> Void) {
		requestBody { header in
			let path = baseUrl + "bookings/end?lat=\(coordinates[0])&long=\(coordinates[1])"
			let parameters: [String:String] = ["address": endStreet]
			AF.request(path, method: .put, parameters: parameters, encoder: JSONParameterEncoder.default, headers: header).validate().responseData { response in
				let result: Result<EndTrip> = handleResponse(response: response)
				callback(result)
			}
		}
	}

	static func updateTrip(_ callback: @escaping (Result<OngoingTrip>) -> Void) {
		requestBody { header in
			let path = baseUrl + "bookings/ongoing"
			AF.request(path, method: .get, headers: header).validate().responseData { response in
				let result: Result<OngoingTrip> = handleResponse(response: response)
				callback(result)
			}
		}
	}

	static func uploadLicense(selectedImage: UIImage, _ callback: @escaping (Result<UploadImage>) -> Void) {
		requestBody { header in
			let path = baseUrl + "user/upload"
			let imageData = selectedImage.jpegData(compressionQuality: 0.85)
			AF.upload(multipartFormData: { multipartFormData in
						if let data = imageData {
							multipartFormData.append(data, withName: "file", fileName: "image.jpg")
						} }, to: path, usingThreshold: UInt64.init(), method: .post, headers: header, fileManager: FileManager.default).validate().responseData {
							response in
							let result: Result<UploadImage> = handleResponse(response: response)
							callback(result)
						}
		}
	}
}
