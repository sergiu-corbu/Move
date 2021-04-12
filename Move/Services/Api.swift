//
//  Api.swift
//  Move
//
//  Created by Sergiu Corbu on 12.04.2021.
//

import Foundation
import Alamofire

struct APIError: Error {
    var message:String
    var localizedDescription: String {
        return message
    }
}

typealias Result<T> = Swift.Result<T, Error>

class API {
    static let baseUrl: String = "https://escooter-tapp.herokuapp.com/api/"
    
    static func register(username: String, email: String, password: String, _ callback: @escaping (Result<User>) -> Void ) {
        
        let path = baseUrl + "user/register"
        AF.request( path, method: .post, parameters: [ "email": email, "username": username, "password": password ], encoder: JSONParameterEncoder.default).response {  response in
            if let data = response.data {
                let debugString = String(data: data, encoding: .utf8)
                print(debugString ?? "")
                do {
                    let user = try JSONDecoder().decode(User.self, from: data)
                    callback(.success(user))
                } catch (let error) {
                    callback(.failure(error))
                }
            } else {
                callback(.failure(APIError(message: "Missing data")))
            }
        }
    }
}
