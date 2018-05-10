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
    request.setValue("application/json", forHTTPHeaderField: "Accept")
    return request
  }

  static func patch<T: Encodable>(url: URL, headers: [String: String] = [:], object: T) -> URLRequest {
    var request = urlRequest(with: url, headers: headers)
    request.httpMethod = "PATCH"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")


    do {
      let data = try JSONEncoder().encode(object)
      request.httpBody = data
    }
    catch {
      // Error
      Logger.error("Cannot serialize object: \(object)")
    }

    return request
  }

  // MARK: - Private

  static func urlRequest(with url: URL, headers: [String: String]) -> URLRequest {
    var request = URLRequest(url: url)
    headers.forEach { request.addValue($0.key, forHTTPHeaderField: $0.value) }
    return request
  }


}
