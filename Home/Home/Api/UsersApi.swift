//
//  UsersApi.swift
//  Home
//
//  Created by Sebastien Villar on 04/04/2018.
//  Copyright © 2018 -. All rights reserved.
//

import Foundation

class UsersApi {

  static let userId = "sebastienvillar"

  private struct Constants {
    static let usersEndpoint = "\(Api.endpoint)/users"
    static let currentUserEndpoint = "\(Api.endpoint)/users/\(userId)"
  }

  static func getUsers(completion: @escaping Api.FetchCompletion<UsersModel>) {
    let request = URLRequest.get(url: URL(string: Constants.usersEndpoint)!)
    URLSession.shared.object(with: request, completion: completion)
  }

  static func getUser(completion: @escaping Api.FetchCompletion<UserModel>) {
    let request = URLRequest.get(url: URL(string: Constants.currentUserEndpoint)!)
    URLSession.shared.object(with: request, completion: completion)
  }

  static func patchUser(model: UserModel, completion: @escaping Api.SetCompletion) {
    let request = URLRequest.patch(url: URL(string: Constants.currentUserEndpoint)!, object: model)
    URLSession.shared.send(with: request, completion: completion)
  }
}
