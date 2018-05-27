//
//  RootVC.swift
//  Home
//
//  Created by Sebastien Villar on 04/04/2018.
//  Copyright © 2018 -. All rights reserved.
//

import UIKit

class RootVC: UIViewController {

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
      guard let `self` = self, success else {
        // Show error/offline screen depending on error
        // rootView.setup(with: ....)
        return
      }

      if self.controllers == nil {
        // Setup controllers
        let thermostatController = ThermostatController(dataSource: self.dataSource)
        let userController = UserController(dataSource: self.dataSource)
        self.controllers = [
          thermostatController,
          userController,
        ]

        // Setups view collection
        let viewCollection = RootView.ViewCollection(
          thermostatTemperatureView: thermostatController.temperatureView,
          thermostatTemperatureAdjustmentView: thermostatController.temperatureAdjustmentView,
          userView: userController.userView
        )

        // Setup root view
        self.rootView.setup(with: viewCollection)
        self.rootView.setup(with: .ready)
      }
    }
  }
}
