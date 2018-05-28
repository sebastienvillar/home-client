//
//  LightsApi.swift
//  Home
//
//  Created by Sebastien Villar on 5/28/18.
//  Copyright © 2018 -. All rights reserved.
//

import Foundation

class LightsApi {

  private struct Constants {
    static let endpoint = "\(Api.endpoint)/lights"
  }

  static func patch(id: String, model: LightModel, completion: @escaping Api.SetCompletion<RootModel>) {
    let endPoint = "\(Constants.endpoint)/\(id)"
    let request = URLRequest.patch(url: URL(string: endPoint)!, object: model)
    NetworkSession.shared.send(with: request, completion: completion)
  }
}
