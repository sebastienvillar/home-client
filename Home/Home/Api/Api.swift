//
//  Api.swift
//  Home
//
//  Created by Sebastien Villar on 5/9/18.
//  Copyright © 2018 -. All rights reserved.
//

import Foundation

struct Api {
  static let endpoint = "https://\(Config.shared.homeIP)"

  typealias FetchCompletion<T: Decodable> = (_ response: NetworkSession.FetchResponse<T>) -> Void
  typealias SetCompletion<T: Decodable> = (_ response: NetworkSession.SetResponse<T>) -> Void
}
