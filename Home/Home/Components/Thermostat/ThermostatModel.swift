//
//  Copyright 2013-2018 Microsoft Inc.
//

import Foundation
import UIKit

struct ThermostatModel: Decodable {

  // MARK: - Public

  enum Mode: String, Decodable {
    case heat
    case cool
  }

  enum Status: String, Decodable {
    case on
    case off
  }

  let temperature: CGFloat
  let targetTemperature: CGFloat
  let mode: Mode
  let status: Status
}
