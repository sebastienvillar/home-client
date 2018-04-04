//
//  AwayController.swift
//  Home
//
//  Created by Sebastien Villar on 5/6/18.
//  Copyright © 2018 -. All rights reserved.
//

import Foundation

class AwayController {

  lazy var awayView = AwayView()

  // MARK: - Public

  init(dataSource: DataSource) {
    // Register changes
    dataSource.subscribeToChange(for: .away, block: DataSource.ChangeBlock(block: { [weak self] in
      self?.handleAwayModelChange(model: dataSource.awayModel)
    }))
  }

  // MARK: - Private

  private func handleAwayModelChange(model: AwayModel?) {
    guard let model = model else {
      return
    }

    awayView.setup(with: AwayViewModel(model: model))
  }
}
