//
//  UserModel.swift
//  Home
//
//  Created by Sebastien Villar on 5/6/18.
//  Copyright © 2018 -. All rights reserved.
//

import Foundation

struct UserModel: Codable, Equatable {

  static func == (lhs: UserModel, rhs: UserModel) -> Bool {
    return (
      lhs.awayMethod == rhs.awayMethod &&
        lhs.awayValue == rhs.awayValue
    )
  }

  // MARK: - Public

  enum CodingKeys: String, CodingKey
  {
    case awayMethod
    case awayValue

    static let all: [CodingKeys] = [.awayMethod, .awayValue]
  }

  enum AwayMethod: String, Codable {
    case auto
    case manual
  }

  enum AwayValue: String, Codable {
    case away
    case home
  }

  var awayMethod: AwayMethod
  var awayValue: AwayValue

  var keysToEncode: [Any] = CodingKeys.all // Any because it triggers a segmentation fault otherwised

  // MARK: - Super overrides

  func encode(to encoder: Encoder) throws
  {
    var container = encoder.container(keyedBy: CodingKeys.self)
    let keys = Set((keysToEncode as? [CodingKeys] ?? CodingKeys.all))

    if keys.contains(.awayMethod) {
      try container.encode(awayMethod, forKey: .awayMethod)
    }

    if keys.contains(.awayValue) {
      try container.encode(awayValue, forKey: .awayValue)
    }
  }
}
