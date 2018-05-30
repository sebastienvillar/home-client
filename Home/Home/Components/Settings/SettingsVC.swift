//
//  SettingsVC.swift
//  Home
//
//  Created by Sebastien Villar on 5/29/18.
//  Copyright © 2018 -. All rights reserved.
//

import Foundation
import UIKit

class SettingsVC: UIViewController {

  // MARK: - Public

  init(dataSource: DataSource) {
    self.dataSource = dataSource

    super.init(nibName: nil, bundle: nil)

    // Register changes
    dataSource.subscribeToChange(for: .thermostat, block: DataSource.ChangeBlock(block: { [weak self] in
      guard let data = self?.updatedData() else {
        return
      }

      self?.mainView.setup(with: data)
    }))
  }


  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Super overrides

  override func loadView() {
    self.view = SettingsView(data: updatedData())

    mainView.onCancel = { [weak self] in
      self?.dismiss(animated: true, completion: nil)
    }

    mainView.onNewMode = { [weak self] mode in
      guard let `self` = self else {
        return
      }

      switch mode {
      case .warm:
        ThermostatManager.setMode(.warm, dataSource: self.dataSource)
      case .cool:
        ThermostatManager.setMode(.cool, dataSource: self.dataSource)
      }
    }
  }

  // MARK: - Private

  private var mainView: SettingsView { return view as! SettingsView }
  private let dataSource: DataSource

  private func updatedData() -> SettingsView.Data {
    guard let thermostatModel = dataSource.thermostatModel else {
      return SettingsView.Data(sectionToRows: [:], sections: [])
    }

    let thermostatModeRows: [SettingsView.Data.Row] = [
      .warm(checked: thermostatModel.mode == .warm),
      .cool(checked: thermostatModel.mode == .cool),
    ]

    return SettingsView.Data(
      sectionToRows: [
        .thermostatMode: thermostatModeRows
      ],
      sections: [.thermostatMode]
    )
  }
}
