//
//  RootViewController.swift
//  Home
//
//  Created by Sebastien Villar on 04/04/2018.
//  Copyright © 2018 -. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {

  // MARK: - Public

  init() {
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Super overrides

  override func loadView() {
    self.view = RootView()
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    // Start loading
    rootView.setup(with: .loading)

    // Refresh the data
    refreshData()
  }

  // MARK: - Private

  private var rootView: RootView { return view as! RootView }
  private let dataSource = DataSource()
  private var controllers: [Any]?

  private func refreshData() {
    dataSource.refresh { [weak self] success in
      guard success else {
        // Show error/offline screen depending on error
        // rootView.setup(with: ....)
        return
      }

      if self?.controllers == nil {
        // Setup controllers
        let thermostatController = ThermostatController(dataSource: dataSource)
        let awayController = AwayController(dataSource: dataSource)
        self?.controllers = [
          thermostatController,
          awayController,
        ]

        // Setups view collection
        let viewCollection = RootView.ViewCollection(
          thermostatTemperatureView: thermostatController.temperatureView,
          thermostatTemperatureAdjustmentView: thermostatController.temperatureAdjustmentView,
          awayView: awayController.awayView
        )

        // Setup root view
        rootView.setup(with: viewCollection)
        rootView.setup(with: .ready)
      }
    }
  }
}
