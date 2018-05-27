//
//  NetworkSession.swift
//  Home
//
//  Created by Sebastien Villar on 5/27/18.
//  Copyright © 2018 -. All rights reserved.
//

import Foundation

class NetworkSession {

  static let shared = NetworkSession()
  static let userId = "sebastienvillar"

  // MARK: - Public

  enum FetchResponse<T: Decodable> {
    case success(object: T)
    case failure(statusCode: Int, message: String)
  }

  enum SetResponse<T: Decodable> {
    case success(httpResponse: HTTPURLResponse, object: T?)
    case failure(statusCode: Int, message: String)
  }

  typealias FetchCompletion<T: Decodable> = (_ response: FetchResponse<T>) -> Void
  typealias SetCompletion<T: Decodable> = (_ response: SetResponse<T>) -> Void

  func isLastResponse(_ response: HTTPURLResponse) -> Bool {
    guard let id = response.allHeaderFields["X-Request-Id"] as? String else {
      return true
    }

    let requestID = UUID(uuidString: id)
    return requestID == currentRequestID
  }

  func object<T: Decodable>(with urlRequest: URLRequest, completion: @escaping FetchCompletion<T>) {
    let urlRequest = prepareRequest(urlRequest)
    let task = session.dataTask(with: urlRequest) { data, response, error in
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

  func send<T: Decodable>(with urlRequest: URLRequest, completion: @escaping SetCompletion<T>) {
    let urlRequest = prepareRequest(urlRequest)
    let task = session.dataTask(with: urlRequest) { data, response, error in
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
        completion(.success(httpResponse: urlResponse, object: nil))
        return
      }

      do {
        let object = try JSONDecoder().decode(T.self, from: data)
        completion(.success(httpResponse: urlResponse, object: object))
      }
      catch let error {
        completion(.failure(statusCode: urlResponse.statusCode, message: "\(error)"))
      }
    }

    task.resume()
  }

  // MARK: - Private

  private let session = URLSession.shared
  private var currentRequestID: UUID?

  private func prepareRequest(_ request: URLRequest) -> URLRequest {
    // Add ID
    currentRequestID = UUID()
    var urlRequest = request
    urlRequest.addValue(currentRequestID!.uuidString, forHTTPHeaderField: "X-Request-Id")

    // Add query parameter
    var urlComponents = URLComponents(url: urlRequest.url!, resolvingAgainstBaseURL: false)!
    urlComponents.queryItems = urlComponents.queryItems ?? []
    urlComponents.queryItems?.append(URLQueryItem(name: "id", value: NetworkSession.userId))
    urlRequest.url = urlComponents.url
    
    return urlRequest
  }
}
