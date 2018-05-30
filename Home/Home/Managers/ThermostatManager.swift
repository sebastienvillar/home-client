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
      DispatchQueue.main.async {
        switch response {
        case .success(let httpResponse, let model):
          dataSource.updateIfNeeded(with: httpResponse, model: model)
          break
        case .failure(let statusCode, let message):
          AlertController.shared.show(request: "Set targetTemperature", statusCode: statusCode, message: message)
          break
        }
      }
    }
  }

  static func setMode(_ mode: ThermostatModel.Mode, dataSource: DataSource) {
    guard var thermostatModel = dataSource.thermostatModel else {
      return
    }

    thermostatModel.mode = mode
    thermostatModel.keysToEncode = [ThermostatModel.CodingKeys.mode]
    dataSource.thermostatModel = thermostatModel

    ThermostatApi.patch(model: thermostatModel) { response in
      DispatchQueue.main.async {
        switch response {
        case .success(let httpResponse, let model):
          dataSource.updateIfNeeded(with: httpResponse, model: model)
          break
        case .failure(let statusCode, let message):
          AlertController.shared.show(request: "Set mode", statusCode: statusCode, message: message)
          break
        }
      }
    }
  }
}
