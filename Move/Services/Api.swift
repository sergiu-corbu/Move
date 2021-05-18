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
			} else { //guard ... for inactive network
				guard let result = response.data else { return .failure(APIError(message: "network error")) }
				let result1 = try JSONDecoder().decode(APIError.self, from: result)
				return .failure(APIError(message: result1.localizedDescription))
			}
		} catch (let error) {
			return .failure(error)
		}
	}
	
	static func registerUser(email: String, password: String, username: String, _ callback: @escaping (Result<AuthResult>) -> Void) {
		let path = baseUrl + "users/register"
		let parameters = ["email": email, "username": username, "password": password]
		AF.request(path, method: .post, parameters: parameters, encoder: JSONParameterEncoder.default).validate().responseData { response in
			let result: Result<AuthResult> = handleResponse(response: response)
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
	
    static func getScooters(coordinates: CLLocationCoordinate2D ,_ callback: @escaping (Result<[Scooter]>) -> Void) {
		let path = baseUrl + "scooters/inradius?longitude=\(coordinates.longitude)&latitude=\(coordinates.latitude)"
        let parameters = ["longitude": coordinates.longitude, "latitude": coordinates.latitude]
		AF.request(path, parameters: parameters).validate().responseData { response in
			let result: Result<[Scooter]> = handleResponse(response: response)
			callback(result)
		}
	}
    	
	static func unlockScooterPin(scooterID: String, code: String, _ callback: @escaping (Result<StartTrip>) -> Void) {
		requestBody { header in
			let path = baseUrl + "bookings/code/" + scooterID
			let coordinates: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 46.7566, longitude: 23.594)
			let parameters = ["long": String(coordinates.longitude), "lat": String(coordinates.latitude), "code": code]
			AF.request(path, method: .post, parameters: parameters, headers: header).validate().responseData { response in
				let result: Result<StartTrip> = handleResponse(response: response)
				callback(result)
			}
		}
	}
	
	static func downloadTrips(_ callback: @escaping (Result<TripResult>) -> Void) {
		/*guard let token = Session.tokenKey else {
			callback(.failure(APIError(message: "invalid token")))
			return
		}
		let path = baseUrl + "bookings/?start=0&PageSize=10"
		let header: HTTPHeaders = ["Authorization": token]
		AF.request(path, method: .get, headers: header).validate().responseData { response in
			let result: Result<TripDownload> = handleResponse(response: response)
			
			if let trips = try? result.get() {
				var trips = trips
				DispatchQueue.global(qos: .userInteractive).async {
					let dispatchGroup = DispatchGroup()
					var result: [Trip] = []
					for trip in trips.trips {
						dispatchGroup.enter()
						trip.computeAddress { trip in
							result.append(trip)
							dispatchGroup.leave()
						}
						dispatchGroup.wait()
					}
					trips.trips = result
					trips.totalTrips = result.count
					DispatchQueue.main.async {
						callback(.success(trips))
					}
				}
			} else {
				callback(result)
			}
		}*/
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
	
	static func endTrip(scooterID: String, _ callback: @escaping (Result<EndTripResult>) -> Void) {
		requestBody { header in
			let path = baseUrl + "bookings/end?tag=\(scooterID)"
			let parameters: [String:String] = ["tag": scooterID]
			AF.request(path, method: .put, parameters: parameters, headers: header).validate().responseData { response in
				let result: Result<EndTripResult> = handleResponse(response: response)
				callback(result)
			}
		}
	}
	
	static func updateTrip(_ callback: @escaping (Result<CurrentTripResult>) -> Void) {
		requestBody { header in
			let path = baseUrl + "bookings/ongoing"
			AF.request(path, method: .get, headers: header).validate().responseData { response in
				let result: Result<CurrentTripResult> = handleResponse(response: response)
				callback(result)
			}
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
	
	static func pingScooter(scooterKey: String, _ callback: @escaping (Result<Ping>) -> Void) {
		requestBody { header in
			let path = baseUrl + "users/ping/"
			let coordinates: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 46.7566, longitude: 23.594)
			let parameters = ["long": String(coordinates.longitude), "lat": String(coordinates.latitude), "deviceKey": scooterKey]
			AF.request(path, method: .post, parameters: parameters, headers: header).validate().responseData { response in
				let result: Result<Ping> = handleResponse(response: response)
				callback(result)
			}
		}
	}
}
