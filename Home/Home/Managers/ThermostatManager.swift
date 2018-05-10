//
//  ThermostatManager.swift
//  Home
//
//  Created by Sebastien Villar on 5/9/18.
//  Copyright © 2018 -. All rights reserved.
//

import Foundation
import UIKit

class ThermostatManager {

  static func setTargetTemperature(_ temperature: CGFloat, dataSource: DataSource) {
    guard var thermostatModel = dataSource.thermostatModel else {
      return
    }

    thermostatModel.targetTemperature = temperature
    thermostatModel.keysToEncode = [ThermostatModel.CodingKeys.targetTemperature]
    dataSource.thermostatModel = thermostatModel

    ThermostatApi.patch(model: thermostatModel) { response in
      switch response {
      case .success:
        break
      case .failure:
        break
      }
    }
  }
}
