//
//  ThermostatController.swift
//  Home
//
//  Created by Sebastien Villar on 04/04/2018.
//  Copyright © 2018 -. All rights reserved.
//

import Foundation

class ThermostatController {

  lazy var temperatureView = ThermostatTemperatureView()
  lazy var temperatureAdjustmentView = ThermostatTemperatureAdjustmentView()

  // MARK: - Public

  init(dataSource: DataSource) {
    // Register changes
    dataSource.subscribeToChange(for: .thermostat, block: DataSource.ChangeBlock(block: { [weak self] in
      self?.handleThermostatModelChange(model: dataSource.thermostatModel)
    }))
  }

  // MARK: - Private

  private func handleThermostatModelChange(model: ThermostatModel?) {
    guard let model = model else {
      return
    }

    temperatureView.setup(with: ThermostatTemperatureViewModel(model: model))
  }
}
