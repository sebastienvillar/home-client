//
//  ThermostatTemperatureAdjustmentView.swift
//  Home
//
//  Created by Sebastien Villar on 04/04/2018.
//  Copyright © 2018 -. All rights reserved.
//

import Foundation
import UIKit

class ThermostatTemperatureAdjustmentView: UIView {

  // MARK: - Public

  init() {
    super.init(frame: .zero)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func setup(with model: ThermostatModel) {
    // Update view
  }

  // MARK: - Super overrides

  override func layoutSubviews() {
    super.layoutSubviews()
  }

  // MARK: - Private

  private var model: ThermostatModel?

}

