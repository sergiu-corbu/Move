//
//  Api.swift
//  Move
//
//  Created by Sergiu Corbu on 12.04.2021.
//

import Foundation
import Alamofire
import CoreLocation

struct APIError: Error, Decodable {
    var message: String
    var localizedDescription: String { return message }
	
	enum CodingKeys: String, CodingKey {
		case message = "message"
	}
}

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
			if response.response?.statusCode == 200 {
				do {
					let result = try JSONDecoder().decode(AuthResult.self, from: response.data!)
						callback(.success(result))
				} catch (let error) { print(error) }
			} else {
				do {
					let result = try JSONDecoder().decode(APIError.self, from: response.data!)
						callback(.failure(APIError(message: result.localizedDescription)))
				} catch (let error) { print(error) }
			}
		}
	}
	
	static func register(username: String, email: String, password: String, _ callback: @escaping (Result<AuthResult>) -> Void) {
		let path = baseUrl + "user/register"
		AF.request(path, method: .post, parameters: ["email": email, "username": username, "password": password], encoder: JSONParameterEncoder.default).validate()
			.responseData {  response in
				if response.response?.statusCode == 200 {
					do {
						let result = try JSONDecoder().decode(AuthResult.self, from: response.data!)
						callback(.success(result))
					} catch (let error) { print(error) }
				} else {
					do {
						let result = try JSONDecoder().decode(APIError.self, from: response.data!)
						callback(.failure(APIError(message: result.localizedDescription)))

					} catch (let error) { print(error) }
				}
			}
	}
    
    static func login(email: String, password: String, _ callback: @escaping (Result<AuthResult>) -> Void) {
        let path = baseUrl + "user/login"
		AF.request(path, method: .post, parameters: [ "email": email, "password": password ], encoder: JSONParameterEncoder.default).validate().responseData {  response in
			if response.response?.statusCode == 200 {
				do {
					let result = try JSONDecoder().decode(AuthResult.self, from: response.data!)
					callback(.success(result))
				} catch (let error) { print(error) }
			} else {
				do {
					let result = try JSONDecoder().decode(APIError.self, from: response.data!)
					callback(.failure(APIError(message: result.localizedDescription)))
					
				} catch (let error) { print(error) }
			}
        }
    }
    
    static func getScooters(coordinates: CLLocationCoordinate2D ,_ callback: @escaping (Result<[Scooter]>) -> Void) {
        let path = baseUrl + "scooter/"
		//scooter/inradius/
        let parameters = ["longitude": coordinates.longitude, "latitude": coordinates.latitude]
		AF.request(path, parameters: parameters).validate().responseData { response in
			if response.response?.statusCode == 200 {
				do {
					let result = try JSONDecoder().decode([Scooter].self, from: response.data!)
					callback(.success(result))
				} catch (let error) { print(error) }
			} else {
				do {
					let result = try JSONDecoder().decode(APIError.self, from: response.data!)
					callback(.failure(APIError(message: result.localizedDescription)))
					
				} catch (let error) { print(error) }
			}
        }
    }
    
    static func logout(_ callback: @escaping (Result<Bool>) -> Void) {
		guard let token = Session.tokenKey else { showError(error: "Invalid token"); return}
        let path = baseUrl + "user/logout"
        let header: HTTPHeaders = ["Authorization": token]
		AF.request(path, method: .delete, headers: header).validate().responseData { response in
			if response.response?.statusCode == 200 {
				callback(.success(true))
			} else {
				do {
					let result = try JSONDecoder().decode(APIError.self, from: response.data!)
					callback(.failure(APIError(message: result.localizedDescription)))
				} catch (let error) { print(error) }
			}
		}
	}
	
	static func unlockScooterPin(code: String, _ callback: @escaping (Result<UnlockResult>) -> Void) {
		guard let token = Session.tokenKey else { print("invalid token"); return}
		
		let path = baseUrl + "user/book/code/g6i6"
		let header: HTTPHeaders = ["Authorization": token]
		let coordinates: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 46.7566, longitude: 23.594)
		let parameters = ["long": String(coordinates.longitude), "lat": String(coordinates.latitude), "code": code]
		AF.request(path, method: .post, parameters: parameters, headers: header).validate().responseData { response in
			if response.response?.statusCode == 200 {
				do {
					let result = try JSONDecoder().decode(UnlockResult.self, from: response.data!)
					callback(.success(result))
				} catch (let error) { print(error) }
			} else {
				do {
					let result = try JSONDecoder().decode(APIError.self, from: response.data!)
					callback(.failure(APIError(message: result.localizedDescription)))
				} catch (let error) { print(error) }
			}
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
				{
					print("i am on error")
					callback(.failure(APIError(message: error.localizedDescription))) }
			} else {
				do {
					let result = try JSONDecoder().decode(APIError.self, from: response.data!)
					callback(.failure(APIError(message: result.localizedDescription)))
					
				} catch (let error) { print(error) }
			}
		}
	}
	
	static func endTrip(_ callback: @escaping (Result<EndTripResult>) -> Void) {
		guard let token = Session.tokenKey else { print("invalid token"); return }
		let path = baseUrl + "user/book/end"
		let header: HTTPHeaders = ["Authorization": token]
		AF.request(path, method: .put, headers: header).validate().responseData { response in
			if response.response?.statusCode == 200 {
				do {
					let result = try JSONDecoder().decode(EndTripResult.self, from: response.data!)
					callback(.success(result))
				} catch (let error) { print(error) }
			} else {
				do {
					let result = try JSONDecoder().decode(APIError.self, from: response.data!)
					callback(.failure(APIError(message: result.localizedDescription)))
				} catch (let error) { print(error) }
			}
		}
	}
	
	static func lockScooter(_ callback: @escaping (Result<LockScooter>) -> Void) {
		guard let token = Session.tokenKey else { print("invalid token"); return }
		let path = baseUrl + "user/book/lock"
		let header: HTTPHeaders = ["Authorization": token]
		AF.request(path, method: .put, headers: header).validate().responseData { response in
			if response.response?.statusCode == 200 {
				do {
					let result = try JSONDecoder().decode(LockScooter.self, from: response.data!)
					callback(.success(result))
				} catch (let error) { print(error) }
			} else {
				do {
					let result = try JSONDecoder().decode(APIError.self, from: response.data!)
					callback(.failure(APIError(message: result.localizedDescription)))
				} catch (let error) { print(error) }
			}
		}
	}
	
	static func unlockScooter(_ callback: @escaping (Result<UnlockScooter>) -> Void) {
		guard let token = Session.tokenKey else { print("invalid token"); return }
		let path = baseUrl + "user/book/unlock"
		let header: HTTPHeaders = ["Authorization": token]
		AF.request(path, method: .put, headers: header).validate().responseData { response in
			if response.response?.statusCode == 200 {
				do {
					let result = try JSONDecoder().decode(UnlockScooter.self, from: response.data!)
					callback(.success(result))
				} catch (let error) { print(error) }
			} else {
				do {
					let result = try JSONDecoder().decode(APIError.self, from: response.data!)
					callback(.failure(APIError(message: result.localizedDescription)))
				} catch (let error) { print(error) }
			}
		}
	}
	
}
