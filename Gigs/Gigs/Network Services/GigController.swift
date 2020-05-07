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
        case noData, noEncode, noDecode, badResponse, otherError, noToken
    }
    
    typealias CompletionHandler = (Result<Bool, NetworkError>) -> Void
    
    
    //MARK: - Properties -
    var bearer: Bearer?
    var gigs: [Gig] = []
    
    private var baseURL = URL(string: "https://lambdagigapi.herokuapp.com/api")!
    private lazy var signUpURL = baseURL.appendingPathComponent("/users/signup/")
    private lazy var logInURL = baseURL.appendingPathComponent("/users/login/")
    private lazy var gigsURL = baseURL.appendingPathComponent("/gigs/")
    
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
    
    func logIn(as user: User, completion: @escaping CompletionHandler) {
        var request = URLRequest(url: logInURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let encodedUser = try jsonEncoder.encode(user)
            request.httpBody = encodedUser
            
            let logInTask = URLSession.shared.dataTask(with: request) { ( data, response, error) in
                if let error = error {
                    NSLog("A problem occured during sign up: \(error) " + String(describing: error.localizedDescription))
                    completion(.failure(.otherError))
                    return
                }
                
                guard let response = response as? HTTPURLResponse,
                    response.statusCode == 200 else {
                        NSLog("Bad response from server during log in.")
                        completion(.failure(.badResponse))
                        return
                }
                
                guard let data = data else {
                    NSLog("No token recieved from host.")
                    completion(.failure(.noData))
                    return
                }
                
                do {
                    self.bearer = try self.jsonDecoder.decode(Bearer.self, from: data)
                } catch {
                    NSLog("Error decoding bearer token. Please try again. \(error)")
                    completion(.failure(.noDecode))
                    return
                }
                completion(.success(true))
            }
            logInTask.resume()
        } catch {
            NSLog("Failed to encode user data. \(error)")
            completion(.failure(.noEncode))
            return
        }
        
    }
    
    func getAllGigs(completion: @escaping (Result<[Gig], NetworkError>) -> Void) {
        guard let bearer = bearer else {
            NSLog("No token found. Please log in.")
            completion(.failure(.noToken))
            return
        }
        
        var gigsRequest = URLRequest(url: gigsURL)
        gigsRequest.httpMethod = HTTPMethod.get.rawValue
        gigsRequest.setValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")
        
        let gigsTask = URLSession.shared.dataTask(with: gigsRequest) { data, response, error in
            if let error = error {
                NSLog("An error occurred while fetching gigs from the server. \(error) \(error.localizedDescription)")
                completion(.failure(.otherError))
                return
            }
            
            guard let response = response as? HTTPURLResponse,
                response.statusCode == 200 else {
                    NSLog("Bad response from HTTP server when fetching gigs.")
                    completion(.failure(.badResponse))
                    return
            }
            
            guard let data = data else {
                NSLog("No gigs data returned from request.")
                completion(.failure(.noData))
                return
            }
            
            do {
                self.jsonDecoder.dateDecodingStrategy = .iso8601
                let decodedGigs = try self.jsonDecoder.decode([Gig].self, from: data)
                self.gigs = decodedGigs
                completion(.success(decodedGigs))
            } catch {
                NSLog("Could not decode gigs from request. \(error)")
                completion(.failure(.noDecode))
                return
            }
        }
        gigsTask.resume()
    }
    
    func createGig(posting gig: Gig, completion: @escaping (Result<Gig, NetworkError>) -> Void) {
        guard let bearer = bearer else {
            NSLog("No token found. Please log in.")
            completion(.failure(.noToken))
            return
        }
        
        var gigRequest = URLRequest(url: gigsURL)
        gigRequest.httpMethod = HTTPMethod.post.rawValue
        gigRequest.setValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")
        
        do {
            self.jsonEncoder.dateEncodingStrategy = .iso8601
            let jsonGig = try self.jsonEncoder.encode(gig)
            gigRequest.httpBody = jsonGig
            
            let gigTask = URLSession.shared.dataTask(with: gigRequest) { data, response, error in
                if let error = error {
                    NSLog("An error occured posting your gig. Please try again. \(error)")
                    completion(.failure(.otherError))
                    return
                }
                
                guard let response = response as? HTTPURLResponse,
                    response.statusCode == 200 else {
                        NSLog("Bad response when posting gig.")
                        completion(.failure(.badResponse))
                        return
                }
                
                guard let data = data else {
                    NSLog("No data returned when posting gig.")
                    completion(.failure(.noData))
                    return
                }
                
                do {
                    self.jsonDecoder.dateDecodingStrategy = .iso8601
                    let newGig = try self.jsonDecoder.decode(Gig.self, from: data)
                    self.gigs.append(newGig)
                    completion(.success(newGig))
                } catch {
                    NSLog("Error decoding data from JSON.")
                    completion(.failure(.noDecode))
                    return
                }
            }
            gigTask.resume()
            
        } catch {
            NSLog("Something went wrong encoding your gig. Please try again.")
            completion(.failure(.noEncode))
            return
        }
        
        
    }
    
}
