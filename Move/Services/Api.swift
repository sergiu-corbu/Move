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
        AF.request( path, method: .post, parameters: [ "email": email, "username": username, "password": password ], encoder: JSONParameterEncoder.default).response {  response in
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
		
		let path = baseUrl + "user/book/code/tosu"
		let header: HTTPHeaders = ["Authorization": token]
		let coordinates: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 46.7566, longitude: 23.594)
		let parameters = ["long": String(coordinates.longitude), "lat": String(coordinates.latitude), "code": code]
		
		AF.request(path, method: .post, parameters: parameters, headers: header).response { response in
			//print(response)
			print(response.response!.statusCode)
			if let response = response.data {
				do {
					let result = try JSONDecoder().decode(UnlockResult.self, from: response)
					callback(.success(result))
				} catch (let error) { callback(.failure(error)) }
			} else {print("error on unlock pin")}
		}
	}
	
//	static func downloadUser(_ callback: @escaping (Result<UserDataModel>)) {
//
//	}
}


struct UnlockResult: Codable {
	let message: String
	enum CodingKeys: String, CodingKey {
		case message = "message"
	}
}
