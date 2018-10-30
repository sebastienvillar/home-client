//
//  LightModel.swift
//  Home
//
//  Created by Sebastien Villar on 5/28/18.
//  Copyright © 2018 -. All rights reserved.
//

import Foundation

struct LightModel: Codable, Equatable {

  static func == (lhs: LightModel, rhs: LightModel) -> Bool {
    return (
      lhs.id == rhs.id &&
      lhs.name == rhs.name &&
      lhs.status == rhs.status &&
      lhs.brightness == rhs.brightness
    )
  }

  // MARK: - Public

  enum CodingKeys: String, CodingKey
  {
    case id
    case name
    case status
    case brightness

    static let all: [CodingKeys] = [.id, .name, .status, .brightness]
  }

  enum Status: String, Codable {
    case on
    case off
  }

  let id: String
  let name: String
  var status: Status
  var brightness: Int
  var brightnessRatio: Float {
    get {
      return Float(brightness - 1) / 253
    }
    set {
      brightness = 1 + Int(roundf(newValue * 253))
    }
  }

  var keysToEncode: [Any] = CodingKeys.all // Any because it triggers a segmentation fault otherwised

  // MARK: - Super overrides

  func encode(to encoder: Encoder) throws
  {
    var container = encoder.container(keyedBy: CodingKeys.self)
    let keys = Set((keysToEncode as? [CodingKeys] ?? CodingKeys.all))

    if keys.contains(.id) {
      try container.encode(id, forKey: .id)
    }

    if keys.contains(.name) {
      try container.encode(name, forKey: .name)
    }

    if keys.contains(.status) {
      try container.encode(status, forKey: .status)
    }

    if keys.contains(.brightness) {
      try container.encode(brightness, forKey: .brightness)
    }
  }
}
