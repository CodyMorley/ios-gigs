//
//  GigController.swift
//  Gigs
//
//  Created by Cody Morley on 5/5/20.
//  Copyright © 2020 Cody Morley. All rights reserved.
//

import Foundation
import UIKit


class GigController {
    //MARK: - Enums & Type Aliases -
    enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
        case delete = "DELETE"
    }
    
    enum NetworkError: Error {
        case noData, noEncode, noDecode, badResponse, otherError
    }
    
    typealias CompletionHandler = (Result<Bool, NetworkError>) -> Void
    
    
    //MARK: - Properties -
    var bearer: Bearer?
    
    private var baseURL = URL(string: "https://lambdagigapi.herokuapp.com/api")!
    private lazy var signUpURL = baseURL.appendingPathComponent("/users/signup/")
    private lazy var logInURL = baseURL.appendingPathComponent("/users/login/")
    
    private lazy var jsonEncoder = JSONEncoder()
    private lazy var jsonDecoder = JSONDecoder()
    
    
    //MARK: - Network Functions -
    func signUp(as user: User, completion: @escaping CompletionHandler) {
        var request = URLRequest(url: signUpURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let encodedUser = try jsonEncoder.encode(user)
            request.httpBody = encodedUser
            
            let signUpTask = URLSession.shared.dataTask(with: request) { ( _, response, error) in
                if let error = error {
                    NSLog("A problem occured during sign up: \(error) " + String(describing: error.localizedDescription))
                    completion(.failure(.otherError))
                    return
                }
                
                guard let response = response as? HTTPURLResponse,
                    response.statusCode == 200 else {
                        NSLog("Bad response from server during sign up.")
                        completion(.failure(.badResponse))
                        return
                }
                
                completion(.success(true))
            }
            signUpTask.resume()
        } catch {
            NSLog("Failed to encode user data. \(error)")
            completion(.failure(.noEncode))
            return
        }
        
    }
    
    func logIn(){
        
    }
    
    
}
