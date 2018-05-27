//
//  RootApi.swift
//  Home
//
//  Created by Sebastien Villar on 5/27/18.
//  Copyright © 2018 -. All rights reserved.
//

import Foundation

class RootApi {

  private struct Constants {
    static let endpoint = "\(Api.endpoint)/"
  }
  
  static func get(completion: @escaping Api.FetchCompletion<RootModel>) {
    let request = URLRequest.get(url: URL(string: Constants.endpoint)!)
    NetworkSession.shared.object(with: request, completion: completion)
  }
}
