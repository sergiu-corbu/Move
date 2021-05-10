//
//  Api.swift
//  Move
//
//  Created by Sergiu Corbu on 12.04.2021.
//

import Foundation
import Alamofire
import CoreLocation

struct APIError: Error {
    var message: String
    var localizedDescription: String {
        return message
    }
}

typealias Result<T> = Swift.Result<T, Error>

class API {
    static let baseUrl: String = "https://escooter-tapp.herokuapp.com/api/"
	
	static func register(username: String, email: String, password: String, _ callback: @escaping (Result<AuthResult>) -> Void ) {
        let path = baseUrl + "user/register"
		
		AF.request( path, method: .post, parameters: [ "email": email, "username": username, "password": password ], encoder: JSONParameterEncoder.default).validate()
			.response {  response in
				
            if let data = response.data {
				let debugString = String.init(data: data, encoding: .utf8)
				print(debugString)
                do {
                    let result = try JSONDecoder().decode(AuthResult.self, from: data)
                    callback(.success(result))
                } catch (let error) {
                    callback(.failure(error))
                }
            } else {
                callback(.failure(APIError(message: "Missing data")))
            }
        }
    }
    
    static func login(email: String, password: String, _ callback: @escaping (Result<AuthResult>) -> Void) {
        let path = baseUrl + "user/login"
        AF.request(path, method: .post, parameters: [ "email": email, "password": password ], encoder: JSONParameterEncoder.default).response {  response in
            if let data = response.data {
                do {
                    let result = try JSONDecoder().decode(AuthResult.self, from: data)
                    callback(.success(result))
                } catch (let error) {
                    callback(.failure(error))
                }
            } else {
                callback(.failure(APIError(message: "Missing data")))
            }
        }
    }
    
    static func getScooters(coordinates: CLLocationCoordinate2D ,_ callback: @escaping (Result<[Scooter]>) -> Void) {
        let path = baseUrl + "scooter/"
		//scooter/inradius/
        let parameters = ["longitude": coordinates.longitude, "latitude": coordinates.latitude]
        AF.request(path, parameters: parameters).response { response in
            if let data = response.data {
                do {
                    let result = try JSONDecoder().decode([Scooter].self, from: data)
                    callback(.success(result))
                } catch (let error) {
                    callback(.failure(error))
                }
            } else { callback(.failure(APIError(message: "error while getting scooters"))) }
        }
    }
    
    static func logout(_ callback: @escaping (Bool) -> Void) {
		guard let token = Session.tokenKey else { print("invalid token"); return}
        let path = baseUrl + "user/logout"
        let header: HTTPHeaders = ["Authorization": token]
        AF.request(path, method: .delete, headers: header).response { response in
            if let response = response.response {
                let statusCode = response.statusCode
                if statusCode == 200 {
                    callback(true)
                } else { callback(false) }
            } else { print("error on status code")}
        }
    }
	
	static func unlockScooterPin(code: String, _ callback: @escaping (Result<UnlockResult>) -> Void) {
		guard let token = Session.tokenKey else { print("invalid token"); return}
		
		let path = baseUrl + "user/book/code/g6i6"
		let header: HTTPHeaders = ["Authorization": token]
		let coordinates: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 46.7566, longitude: 23.594)
		let parameters = ["long": String(coordinates.longitude), "lat": String(coordinates.latitude), "code": code]
		
		AF.request(path, method: .post, parameters: parameters, headers: header).response { response in
			//print(response)
			print(response.response!.statusCode)
			if let response = response.data {
				do {
					let result = try JSONDecoder().decode(UnlockResult.self, from: response)
					if result.message == "started ride booking" {
						callback(.success(result))
					} else { print("scooter is already booked") }
				} catch (let error) { callback(.failure(error)) }
			} else {print("error on unlock pin")}
		}
	}
	
	static func downloadTrips(_ callback: @escaping (Result<[Trip]>) -> Void) {
		guard let token = Session.tokenKey else { print("invalid token"); return }
		
		let path = baseUrl + "user/book/info/0/0"
		let header: HTTPHeaders = ["Authorization": token]
		AF.request(path, method: .get, headers: header).response { response in
			if let response = response.data {
//				let debugString = String.init(data: response, encoding: .utf8)
//				print(debugString)
				
				do {
					let trips = try JSONDecoder().decode([Trip].self, from: response)
					DispatchQueue.global(qos: .userInteractive).async {
						let dispatchGroup = DispatchGroup()
						var result: [Trip] = []
						for trip in trips {
							dispatchGroup.enter()
							trip.computeAddress { trip in
								result.append(trip)
								dispatchGroup.leave()
							}
							dispatchGroup.wait()
						}
						DispatchQueue.main.async {
							callback(.success(result))
						}
					}
				} catch (let error)
				{
					//print(error)
					callback(.failure(error)) }
			} else { print("error on api call")}
		}
	}
	
	static func endTrip(_ callback: @escaping (Result<EndTripResult>) -> Void) {
		guard let token = Session.tokenKey else { print("invalid token"); return }
		let path = baseUrl + "user/book/end"
		let header: HTTPHeaders = ["Authorization": token]
		AF.request(path, method: .put, headers: header).response { response in
			if let response = response.data {
				do {
					let result = try JSONDecoder().decode(EndTripResult.self, from: response)
					if result.message == "trip ended successfully" {
						callback(.success(result))
					} else {print("errooraaaaaa")}
					
				} catch (let error) { callback(.failure(error))}
			} else {
				print("error on api call")
			}
		}
	}
	
	static func lockScooter(_ callback: @escaping (Result<LockScooter>) -> Void) {
		guard let token = Session.tokenKey else { print("invalid token"); return }
		let path = baseUrl + "user/book/lock"
		let header: HTTPHeaders = ["Authorization": token]
		AF.request(path, method: .put, headers: header).response { response in
			if let response = response.data {
				do {
					let result = try JSONDecoder().decode(LockScooter.self, from: response)
					if result.message == "success" {
						callback(.success(result))
					} else {print("errooraaaaaa")}
					
				} catch (let error) { callback(.failure(error))}
			} else {
				print("error on api call")
			}
		}
	}
	
	static func unlockScooter(_ callback: @escaping (Result<UnlockScooter>) -> Void) {
		guard let token = Session.tokenKey else { print("invalid token"); return }
		let path = baseUrl + "user/book/unlock"
		let header: HTTPHeaders = ["Authorization": token]
		AF.request(path, method: .put, headers: header).response { response in
			if let response = response.data {
				do {
					let result = try JSONDecoder().decode(UnlockScooter.self, from: response)
					if result.message == "success" {
						callback(.success(result))
					} else {print("errooraaaaaa")}
					
				} catch (let error) { callback(.failure(error))}
			} else {
				print("error on api call")
			}
		}
	}
	
}
