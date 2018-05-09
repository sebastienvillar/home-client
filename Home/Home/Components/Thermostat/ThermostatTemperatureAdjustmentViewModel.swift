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
    static let minTemperature = 15
    static let maxTemperature = 30
    static let temperatureInterval = 1
  }

  // MARK: - Public

  var temperatures: [String] {
    return temperatureValues.map { "\($0)º" }
  }

  var selectedTemperatureIndex: Int? {
    let temperature = Int(round(model.targetTemperature))
    return temperatureValues.index(of: temperature)
  }

  init(model: ThermostatModel) {
    self.model = model
  }

  // MARK: - Private

  let model: ThermostatModel

  private let temperatureValues = Array(stride(from: Constants.minTemperature, to: Constants.maxTemperature + Constants.temperatureInterval, by: Constants.temperatureInterval))

}
