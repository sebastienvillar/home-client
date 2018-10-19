//
//  ThermostatCurrentTemperatureViewModel.swift
//  Home
//
//  Created by Sebastien Villar on 5/6/18.
//  Copyright © 2018 -. All rights reserved.
//

import Foundation

struct ThermostatTemperatureViewModel {

  // MARK: - Public

  enum Status {
    case off
    case heating
    case cooling
  }

  var temperature: String {
    let roundedTemperature = round(model.temperature * 10) / 10
    return "\(roundedTemperature)º"
  }

  var status: Status {
    switch model.status {
    case .on:
      switch model.mode {
      case .warm:
        return .heating
      case .cool:
        return .cooling
      }
    case .off:
      return .off
    }
  }

  init(model: ThermostatModel) {
    self.model = model
  }

  // MARK: - Private

  private let model: ThermostatModel
}
