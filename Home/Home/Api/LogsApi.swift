//
//  LogsApi.swift
//  Home
//
//  Created by Sebastien Villar on 10/19/18.
//  Copyright © 2018 -. All rights reserved.
//

import Foundation

class LogsApi {

  private struct Constants {
    static let endpoint = "\(Api.endpoint)/logs"
  }

  static func get(completion: @escaping Api.FetchCompletion<LogsModel>) {
    let request = URLRequest.get(url: URL(string: Constants.endpoint)!)
    NetworkSession.shared.object(with: request, completion: completion)
  }
}
