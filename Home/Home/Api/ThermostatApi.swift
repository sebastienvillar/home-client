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

  static func get(completion: @escaping Api.FetchCompletion<ThermostatModel>) {
    let request = URLRequest.get(url: URL(string: Constants.endpoint)!)
    URLSession.shared.object(with: request, completion: completion)
  }

  static func patch(model: ThermostatModel, completion: @escaping Api.SetCompletion) {
    let request = URLRequest.patch(url: URL(string: Constants.endpoint)!, object: model)
    URLSession.shared.send(with: request, completion: completion)
  }
}
