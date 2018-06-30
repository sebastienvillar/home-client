//
//  UsersApi.swift
//  Home
//
//  Created by Sebastien Villar on 04/04/2018.
//  Copyright © 2018 -. All rights reserved.
//

import Foundation

class UserApi {

  private struct Constants {
    static let userEndpoint = "\(Api.endpoint)/users/\(Config.shared.user)"
  }

  static func patch(model: UserModel, completion: @escaping Api.SetCompletion<RootModel>) {
    let request = URLRequest.patch(url: URL(string: Constants.userEndpoint)!, object: model)
    NetworkSession.shared.send(with: request, completion: completion)
  }

  static func patch(userAwayValue: UserModel.AwayValue, completion: @escaping Api.SetCompletion<RootModel>) {
    let json = [
      UserModel.CodingKeys.awayValue.rawValue: userAwayValue.rawValue
    ]

    let request = URLRequest.patch(url: URL(string: Constants.userEndpoint)!, json: json)
    NetworkSession.shared.send(with: request, completion: completion)
  }
}
