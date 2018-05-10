//
//  Api.swift
//  Home
//
//  Created by Sebastien Villar on 5/9/18.
//  Copyright © 2018 -. All rights reserved.
//

import Foundation

struct Api {
  static let endpoint = "http://192.168.0.3:8080"

  typealias FetchCompletion<T: Decodable> = (_ response: URLSession.FetchResponse<T>) -> Void
  typealias SetCompletion = (_ response: URLSession.SetResponse) -> Void
}
