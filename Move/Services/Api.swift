//
//  Api.swift
//  Move
//
//  Created by Sergiu Corbu on 12.04.2021.
//

import Foundation
import Alamofire
import CoreLocation
import SwiftUI
import NavigationStack

typealias Result<T> = Swift.Result<T, Error>

class API {
	
    static let baseUrl: String = "https://escooter-tapp.herokuapp.com/api/"
	
	static func requestBody(_ callback: @escaping (HTTPHeaders) -> Void) {
		guard let token = Session.tokenKey else {
			showError(error: "Invalid token")
			return
		}
		let header: HTTPHeaders = ["Authorization": token]
		callback(header)
	}
	
	static func handleResponse<T: Decodable>(response: AFDataResponse<Data>) -> Result<T> {
		do {
			if response.response?.statusCode == 200 {
				let result = try JSONDecoder().decode(T.self, from: response.data!)
				return .success(result)
			} else if response.response?.statusCode == 401 {
				Session.tokenKey = nil
				SceneDelegate.navigationStack.push(AuthCoordinator(navigationStack: SceneDelegate.navigationStack))
				return .failure(APIError(message: "User is suspended"))
			} else { //guard ... for inactive network
				guard let result = response.data else { return .failure(APIError(message: "network error")) }
				let result1 = try JSONDecoder().decode(APIError.self, from: result)
				return .failure(APIError(message: result1.localizedDescription))
			}
		} catch (let error) {
			return .failure(error)
		}
	}
	
	//MARK: User
	static func registerUser(email: String, password: String, username: String, _ callback: @escaping (Result<AuthResult>) -> Void) {
		let path = baseUrl + "users/register"
		let parameters = ["email": email, "username": username, "password": password]
		AF.request(path, method: .post, parameters: parameters, encoder: JSONParameterEncoder.default).validate().responseData { response in
			let result: Result<AuthResult> = handleResponse(response: response)
			switch result {
				case .success(let result):
					print(result)
				case .failure(let error):
					print(error)
					if error.localizedDescription == "User is suspended" {
					}
			}
			callback(result)
		}
	}
	
	static func loginUser(email: String, password: String, _ callback: @escaping (Result<AuthResult>) -> Void) {
		let path = baseUrl + "users/login"
		let parameters = ["email": email, "password": password]
		AF.request(path, method: .post, parameters: parameters, encoder: JSONParameterEncoder.default).validate().responseData { response in
			let result: Result<AuthResult> = handleResponse(response: response)
			callback(result)
		}
	}
	
	static func resetPassword(oldPassword: String, newPassword: String, _ callback: @escaping (Result<AuthResult>) -> Void) {
		let path = baseUrl + "users/reset"
		let parameters = ["oldpassword": oldPassword, "newpassword": newPassword]
		AF.request(path, method: .post, parameters: parameters, encoder: JSONParameterEncoder.default).validate().responseData { response in
			let result: Result<AuthResult> = handleResponse(response: response)
			callback(result)
		}
	}
	
	static func logout(_ callback: @escaping (Result<Logout>) -> Void) {
		requestBody { header in
			let path = baseUrl + "users/logout"
			AF.request(path, method: .delete, headers: header).validate().responseData { response in
				let result: Result<Logout> = handleResponse(response: response)
				callback(result)
			}
		}
	}
	
	//MARK: Scooter
    static func getScooters(coordinates: CLLocationCoordinate2D ,_ callback: @escaping (Result<[Scooter]>) -> Void) {
		let path = baseUrl + "scooters/inradius?longitude=\(coordinates.longitude)&latitude=\(coordinates.latitude)"
        let parameters = ["longitude": coordinates.longitude, "latitude": coordinates.latitude]
		AF.request(path, parameters: parameters).validate().responseData { response in
			let result: Result<[Scooter]> = handleResponse(response: response)
			callback(result)
		}
	}

	static func unlockScooterPin(code: String, location: [Double], _ callback: @escaping (Result<StartTrip>) -> Void) {
		requestBody { header in
			let path = baseUrl + "bookings/code/" + code
			let parameters = ["long": String(location[1]), "lat": String(location[0])]
			AF.request(path, method: .post, parameters: parameters, headers: header).validate().responseData { response in
				let result: Result<StartTrip> = handleResponse(response: response)
				callback(result)
			}
		}
	}
	
	static func pingScooter(scooterKey: String, location: [Double], _ callback: @escaping (Result<Ping>) -> Void) {
		requestBody { header in
			let path = baseUrl + "users/ping/"
			let parameters: [String:String] = ["deviceKey": scooterKey,"lat": String(location[0]), "long": String(location[1])]
			print(parameters)
			AF.request(path, method: .post, parameters: parameters, headers: header).validate().responseData { response in
				let result: Result<Ping> = handleResponse(response: response)
				callback(result)
			}
		}
	}
	
	//MARK: Trip
	static func downloadTrips(pageSize: Int, _ callback: @escaping (Result<TripResult>) -> Void) {
		requestBody { header in
			let path = baseUrl + "bookings/?start=0&pageSize=\(pageSize)"
			AF.request(path, method: .get, headers: header).validate().responseData { response in
				let result: Result<TripResult> = handleResponse(response: response)
				callback(result)
			}
		}
	}
	
	static func lockUnlock(path: String, scooterID: String, _ callback: @escaping (Result<LockUnlockResult>) -> Void){
		requestBody { header in
			let path = baseUrl + "scooters/\(path)?tag=\(scooterID)"
			let parameters: [String:String] = ["tag": scooterID]
			AF.request(path, method: .put, parameters: parameters, headers: header).validate().responseData { response in
				let result: Result<LockUnlockResult> = handleResponse(response: response)
				callback(result)
			}
		}
	}
	
	static func endTrip(scooterID: String, startStreet: String, endStreet: String, _ callback: @escaping (Result<EndTripResult>) -> Void) {
		requestBody { header in
			let path = baseUrl + "bookings/end?tag=\(scooterID)"
			let parameters: [String:String] = ["startStreet": startStreet, "endStreet": endStreet]
			AF.request(path, method: .put, parameters: parameters, headers: header).validate().responseData { response in
				let result: Result<EndTripResult> = handleResponse(response: response)
				callback(result)
			}
		}
	}
	
	static func updateTrip(_ callback: @escaping (Result<OngoingTripResult>) -> Void) {
		requestBody { header in
			let path = baseUrl + "bookings/ongoing"
			AF.request(path, method: .get, headers: header).validate().responseData { response in
				let result: Result<OngoingTripResult> = handleResponse(response: response)
				callback(result)
			}
		}
	}
	static func uploadLicense(selectedImage: Image, _ callback: @escaping (Result<UploadImage>) -> Void) {
		requestBody { header in
			let path = baseUrl + "users/upload"
			let uiImage = selectedImage.uiImage()
			let imageData = uiImage.jpegData(compressionQuality: 0.85)
			AF.upload(multipartFormData: { multipartFormData in
				if let data = imageData {
					multipartFormData.append(data, withName: "file", fileName: "image.jpg")
				}
			}, to: path, usingThreshold: UInt64.init(), method: .post, headers: header, fileManager: FileManager.default).validate().responseData {
				response in
				let result: Result<UploadImage> = handleResponse(response: response)
				callback(result)
			}
		}
	}
}
