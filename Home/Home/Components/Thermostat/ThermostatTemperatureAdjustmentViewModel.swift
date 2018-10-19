//
//  ThermostatTemperatureAdjustmentViewModel.swift
//  Home
//
//  Created by Sebastien Villar on 5/6/18.
//  Copyright © 2018 -. All rights reserved.
//

import Foundation

struct ThermostatTemperatureAdjustmentViewModel {

  private struct Constants {
    static let minTemperature: Float = 15
    static let maxTemperature: Float = 30
    static let temperatureInterval: Float = 0.5
  }

  // MARK: - Public

  let temperatureValues = Array(stride(from: Constants.minTemperature, to: Constants.maxTemperature + Constants.temperatureInterval, by: Constants.temperatureInterval))

  var temperatures: [String] {
    return temperatureValues.map {
      let newValue = $0.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", $0) : String($0)
      return "\(newValue)º"
    }
  }

  var selectedTemperatureIndex: Int? {
    let temperature = round(model.targetTemperature / Constants.temperatureInterval) * Constants.temperatureInterval
    return temperatureValues.index(of: temperature)
  }

  init(model: ThermostatModel) {
    self.model = model
  }

  // MARK: - Private

  let model: ThermostatModel

}
