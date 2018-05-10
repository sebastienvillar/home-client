//
//  Copyright 2013-2018 Microsoft Inc.
//

import Foundation
import UIKit

struct ThermostatModel: Codable {

  // MARK: - Public

  enum CodingKeys: String, CodingKey
  {
    case temperature
    case targetTemperature
    case mode
    case status

    static let all: [CodingKeys] = [.temperature, .targetTemperature, .mode, .status]
  }

  enum Mode: String, Codable {
    case warm
    case cool
  }

  enum Status: String, Codable {
    case on
    case off
  }

  let temperature: CGFloat
  var targetTemperature: CGFloat
  var mode: Mode
  let status: Status = .on

  var keysToEncode: [Any] = CodingKeys.all // Any because it triggers a segmentation fault otherwised

  // MARK: - Super overrides

  func encode(to encoder: Encoder) throws
  {
    var container = encoder.container(keyedBy: CodingKeys.self)
    let keys = Set((keysToEncode as? [CodingKeys] ?? CodingKeys.all))

    if keys.contains(.temperature) {
      try container.encode(temperature, forKey: .temperature)
    }

    if keys.contains(.targetTemperature) {
      try container.encode(targetTemperature, forKey: .targetTemperature)
    }

    if keys.contains(.mode) {
      try container.encode(mode, forKey: .mode)
    }

    if keys.contains(.status) {
      try container.encode(status, forKey: .status)
    }
  }
}
