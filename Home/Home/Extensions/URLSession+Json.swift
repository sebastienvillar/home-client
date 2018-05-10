//
//  URLSession+Json.swift
//  Home
//
//  Created by Sebastien Villar on 5/9/18.
//  Copyright © 2018 -. All rights reserved.
//

import Foundation

extension URLSession {

  enum FetchResponse<T: Decodable> {
    case success(object: T)
    case failure(statusCode: Int, message: String)
  }

  enum SetResponse {
    case success
    case failure(statusCode: Int, message: String)
  }

  typealias FetchCompletion<T: Decodable> = (_ response: FetchResponse<T>) -> Void
  typealias SetCompletion = (_ response: SetResponse) -> Void


  func object<T: Decodable>(with urlRequest: URLRequest, completion: @escaping FetchCompletion<T>) {
    let task = dataTask(with: urlRequest) { data, response, error in
      guard let urlResponse = response as? HTTPURLResponse else {
        completion(.failure(statusCode: -1, message: "Couldn't parse to HTTPURLResponse"))
        return
      }

      guard error == nil else {
        completion(.failure(statusCode: urlResponse.statusCode, message: "\(error!)"))
        return
      }

      guard urlResponse.statusCode == 200 else {
        completion(.failure(statusCode: urlResponse.statusCode, message: "Invalid status code"))
        return
      }

      guard let data = data else {
        completion(.failure(statusCode: urlResponse.statusCode, message: "Missing data"))
        return
      }

      do {
        let object = try JSONDecoder().decode(T.self, from: data)
        completion(.success(object: object))
      }
      catch let error {
        completion(.failure(statusCode: urlResponse.statusCode, message: "\(error)"))
      }
    }

    task.resume()
  }

  func send(with urlRequest: URLRequest, completion: @escaping SetCompletion) {
    let task = dataTask(with: urlRequest) { data, response, error in
      guard let urlResponse = response as? HTTPURLResponse else {
        completion(.failure(statusCode: -1, message: "Couldn't parse to HTTPURLResponse"))
        return
      }

      guard error == nil else {
        completion(.failure(statusCode: urlResponse.statusCode, message: "\(error!)"))
        return
      }

      guard urlResponse.statusCode == 200 else {
        completion(.failure(statusCode: urlResponse.statusCode, message: "Invalid status code"))
        return
      }

      completion(.success)
    }

    task.resume()
  }
}
