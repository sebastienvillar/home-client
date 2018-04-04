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
    return "\(Int(round(model.temperature)))º"
  }

  var status: Status {
    switch model.status {
    case .on:
      switch model.mode {
      case .heat:
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
