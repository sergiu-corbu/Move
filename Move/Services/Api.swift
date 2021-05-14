//
//  Api.swift
//  Move
//
//  Created by Sergiu Corbu on 12.04.2021.
//

import Foundation
import Alamofire
import CoreLocation

typealias Result<T> = Swift.Result<T, Error>

class API {
    static let baseUrl: String = "https://escooter-tapp.herokuapp.com/api/"
	
	static func handleResponse<T: Decodable>(response: AFDataResponse<Data>) -> Result<T> {
		do {
			if response.response?.statusCode == 200 {
				let result = try JSONDecoder().decode(T.self, from: response.data!)
				return .success(result)
			} else {
				let result = try JSONDecoder().decode(APIError.self, from: response.data!)
				return .failure(APIError(message: result.localizedDescription))
			}
		} catch (let error) {
			return .failure(error)
		}
	}
	
	static func registerUser( email: String, password: String, username: String, _ callback: @escaping (Result<AuthResult>) -> Void) {
		let path = baseUrl + "user/register"
		let parameters = ["email": email, "username": username, "password": password]
		AF.request(path, method: .post, parameters: parameters, encoder: JSONParameterEncoder.default).validate().responseData { response in
			let result: Result<AuthResult> = handleResponse(response: response)
			callback(result)
		}
	}
	
	static func loginUser( email: String, password: String, _ callback: @escaping (Result<AuthResult>) -> Void) {
		let path = baseUrl + "user/login"
		let parameters = ["email": email, "password": password]
		AF.request(path, method: .post, parameters: parameters, encoder: JSONParameterEncoder.default).validate().responseData { response in
			let result: Result<AuthResult> = handleResponse(response: response)
			callback(result)
		}
	}
	
    static func getScooters(coordinates: CLLocationCoordinate2D ,_ callback: @escaping (Result<[Scooter]>) -> Void) {
		let path = baseUrl + "scooter/inradius?longitude=" + "\(coordinates.longitude)" + "&latitude=" + "\(coordinates.latitude)"
        let parameters = ["longitude": coordinates.longitude, "latitude": coordinates.latitude]
		AF.request(path, parameters: parameters).validate().responseData { response in
			let result: Result<[Scooter]> = handleResponse(response: response)
			callback(result)
		}
	}
    	
	static func unlockScooterPin(scooterID: String, code: String, _ callback: @escaping (Result<BasicCallResult>) -> Void) {
		guard let token = Session.tokenKey else {
			callback(.failure(APIError(message: "..")))
			return}
		let path = baseUrl + "user/book/code/" + scooterID
		let header: HTTPHeaders = ["Authorization": token]
		let coordinates: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 46.7566, longitude: 23.594)
		let parameters = ["long": String(coordinates.longitude), "lat": String(coordinates.latitude), "code": code]
		AF.request(path, method: .post, parameters: parameters, headers: header).validate().responseData { response in
			let result: Result<BasicCallResult> = handleResponse(response: response)
			callback(result)
		}
	}
	
	static func downloadTrips(_ callback: @escaping (Result<TripDownload>) -> Void) {
		guard let token = Session.tokenKey else {
			callback(.failure(APIError(message: "invalid token")))
			return
		}
		
		let path = baseUrl + "user/book/info/0/0"
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
		}
	}
	
	static func basicCall(path: String, _ callback: @escaping (Result<BasicCallResult>) -> Void) {
		guard let token = Session.tokenKey else { print("invalid token"); return }
		let path = baseUrl + "user/" + path
		let header: HTTPHeaders = ["Authorization": token]
		AF.request(path, method: .put, headers: header).validate().responseData { response in
			let result: Result<BasicCallResult> = handleResponse(response: response)
			callback(result)
		}
	}
}
