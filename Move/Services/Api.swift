//
//  Api.swift
//  Move
//
//  Created by Sergiu Corbu on 12.04.2021.
//

import Foundation
import Alamofire
import CoreLocation

typealias Result<T> = Swift.Result<T, APIError>

class API {
    static let baseUrl: String = "https://escooter-tapp.herokuapp.com/api/"
	
	static func authCall(path: String, email: String, password: String, username: String?, _ callback: @escaping (Result<AuthResult>) -> Void) {
		let path = baseUrl + "user/" + path
		let registerParameters = ["email": email, "username": username, "password": password]
		let loginParameters = ["email": email, "password": password]
		var isRegister: Bool {
			if username != nil { return true }
			return false
		}
		
		AF.request(path, method: .post, parameters: isRegister ? registerParameters : loginParameters, encoder: JSONParameterEncoder.default).validate().responseData { response in
			do {
				if response.response?.statusCode == 200 {
					let result = try JSONDecoder().decode(AuthResult.self, from: response.data!)
					callback(.success(result))
				} else {
					let result = try JSONDecoder().decode(APIError.self, from: response.data!)
					callback(.failure(APIError(message: result.localizedDescription)))
				}
			} catch (let error) { print(error) }
		}
	}
	
    static func getScooters(coordinates: CLLocationCoordinate2D ,_ callback: @escaping (Result<[Scooter]>) -> Void) {
		let path = baseUrl + "scooter/inradius?longitude=" + "\(coordinates.longitude)" + "&latitude=" + "\(coordinates.latitude)"
		//scooter/inradius/
        let parameters = ["longitude": coordinates.longitude, "latitude": coordinates.latitude]
		AF.request(path, parameters: parameters).validate().responseData { response in
			do {
				if response.response?.statusCode == 200 {
					let result = try JSONDecoder().decode([Scooter].self, from: response.data!)
					callback(.success(result))
				} else {
					let result = try JSONDecoder().decode(APIError.self, from: response.data!)
					callback(.failure(APIError(message: result.localizedDescription)))
				}
			} catch (let error) { print(error) }
		}
	}
    	
	static func unlockScooterPin(scooterID: String, code: String, _ callback: @escaping (Result<BasicCallResult>) -> Void) {
		guard let token = Session.tokenKey else { showError(error: "Invalid token"); return}
		let path = baseUrl + "user/book/code/" + scooterID
		let header: HTTPHeaders = ["Authorization": token]
		let coordinates: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 46.7566, longitude: 23.594)
		
		let parameters = ["long": String(coordinates.longitude), "lat": String(coordinates.latitude), "code": code]
		
		AF.request(path, method: .post, parameters: parameters, headers: header).validate().responseData { response in
			do {
				if response.response?.statusCode == 200 {
					let result = try JSONDecoder().decode(BasicCallResult.self, from: response.data!)
					callback(.success(result))
				} else {
					let result = try JSONDecoder().decode(APIError.self, from: response.data!)
					callback(.failure(APIError(message: result.localizedDescription)))
				}
			} catch (let error) { print(error) }
		}
	}
	
	static func downloadTrips(_ callback: @escaping (Result<TripDownload>) -> Void) {
		guard let token = Session.tokenKey else { print("invalid token"); return }
		
		let path = baseUrl + "user/book/info/0/0"
		let header: HTTPHeaders = ["Authorization": token]
		AF.request(path, method: .get, headers: header).validate().responseData { response in
			if response.response?.statusCode == 200 {
				do {
					var trips = try JSONDecoder().decode(TripDownload.self, from: response.data!)
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
				} catch (let error)
				{ callback(.failure(APIError(message: error.localizedDescription))) } }
			else {
				do {
					let result = try JSONDecoder().decode(APIError.self, from: response.data!)
					callback(.failure(APIError(message: result.localizedDescription)))
				} catch (let error) { print(error) }
			}
		}
	}
	
	static func basicCall(path: String, _ callback: @escaping (Result<BasicCallResult>) -> Void) {
		guard let token = Session.tokenKey else { print("invalid token"); return }
		let path = baseUrl + "user/" + path
		let header: HTTPHeaders = ["Authorization": token]
		
		AF.request(path, method: .put, headers: header).validate().responseData { response in
			do {
				if response.response?.statusCode == 200 {
						let result = try JSONDecoder().decode(BasicCallResult.self, from: response.data!)
						callback(.success(result))
				} else {
						let result = try JSONDecoder().decode(APIError.self, from: response.data!)
						callback(.failure(APIError(message: result.localizedDescription)))
				}
			} catch (let error) { print(error) }
		}
	}
}


//enum ResultType {
//	var types = [APIError.self, AuthResult.self] as [Any]
//	switch types:
//	case
//}
