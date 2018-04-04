//
//  URLRequest+Methods.swift
//  Home
//
//  Created by Sebastien Villar on 04/04/2018.
//  Copyright © 2018 -. All rights reserved.
//

import Foundation

extension URLRequest {

  // MARK: - Public

  static func get(url: URL, headers: [String: String] = [:]) -> URLRequest {
    var request = urlRequest(with: url, headers: headers)
    request.httpMethod = "GET"
    return request
  }

  static func put<T>(url: URL, headers: [String: String] = [:], json: Json<T>) -> URLRequest {
    var request = urlRequest(with: url, headers: headers)
    request.httpMethod = "PUT"

    do {
      let data = try JSONSerialization.data(withJSONObject: json, options: [])
      request.httpBody = data
    }
    catch {
      // Error
      Logger.error("Cannot serialize Json: \(json)")
    }

    return request
  }

  static func post<T>(url: URL, headers: [String: String] = [:], json: Json<T>) -> URLRequest {
    var request = urlRequest(with: url, headers: headers)
    request.httpMethod = "POST"

    do {
      let data = try JSONSerialization.data(withJSONObject: json, options: [])
      request.httpBody = data
    }
    catch {
      // Error
      Logger.error("Cannot serialize Json: \(json)")
    }

    return request
  }

  static func delete(url: URL, headers: [String: String] = [:]) -> URLRequest {
    var request = urlRequest(with: url, headers: headers)
    request.httpMethod = "DELETE"
    return request
  }

  // MARK: - Private

  static func urlRequest(with url: URL, headers: [String: String]) -> URLRequest {
    var request = URLRequest(url: url)
    headers.forEach { request.addValue($0.key, forHTTPHeaderField: $0.value) }
    return request
  }


}
