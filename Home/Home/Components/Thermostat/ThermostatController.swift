//
//  ThermostatController.swift
//  Home
//
//  Created by Sebastien Villar on 04/04/2018.
//  Copyright © 2018 -. All rights reserved.
//

import Foundation
import UIKit

class ThermostatController {

  lazy var temperatureView = ThermostatTemperatureView()
  lazy var temperatureAdjustmentView = ThermostatTemperatureAdjustmentView(selectionHandler: { [weak self] temperature in
    self?.handleTemperatureSelection(temperature)
  })

  // MARK: - Public

  init(dataSource: DataSource) {
    self.dataSource = dataSource

    // Register changes
    dataSource.subscribeToChange(for: .thermostat, block: DataSource.ChangeBlock(block: { [weak self] in
      self?.handleThermostatModelChange(model: dataSource.thermostatModel)
    }))
  }

  // MARK: - Private

  let dataSource: DataSource

  private func handleThermostatModelChange(model: ThermostatModel?) {
    guard let model = model else {
      return
    }

    temperatureView.setup(with: ThermostatTemperatureViewModel(model: model))
    temperatureAdjustmentView.setup(with: ThermostatTemperatureAdjustmentViewModel(model: model))
  }

  private func handleTemperatureSelection(_ temperature: Float) {
    ThermostatManager.setTargetTemperature(temperature, dataSource: dataSource)
  }
}
