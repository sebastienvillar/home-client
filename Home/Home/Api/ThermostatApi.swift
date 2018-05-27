//
//  ThermostatApi.swift
//  Home
//
//  Created by Sebastien Villar on 04/04/2018.
//  Copyright © 2018 -. All rights reserved.
//

import Foundation

class ThermostatApi {

  private struct Constants {
    static let endpoint = "\(Api.endpoint)/thermostat"
  }

  static func patch(model: ThermostatModel, completion: @escaping Api.SetCompletion<RootModel>) {
    let request = URLRequest.patch(url: URL(string: Constants.endpoint)!, object: model)
    NetworkSession.shared.send(with: request, completion: completion)
  }
}
