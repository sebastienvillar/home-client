//
//  LightsController.swift
//  Home
//
//  Created by Sebastien Villar on 5/28/18.
//  Copyright © 2018 -. All rights reserved.
//

import Foundation

class LightsController {

  lazy var lightsView = LightsView(tapHandler: { [weak self] lightID in
    self?.handleLightTap(lightID: lightID)
  })

  // MARK: - Public

  init(dataSource: DataSource) {
    self.dataSource = dataSource

    // Register changes
    dataSource.subscribeToChanges(for: [.lights], block: DataSource.ChangeBlock(block: { [weak self] in
      self?.handleLightModelsChange(lightModels: dataSource.lightModels)
    }))
  }

  // MARK: - Private

  private let dataSource: DataSource

  // MARK: Handlers

  private func handleLightModelsChange(lightModels: [LightModel]?) {
    guard let lightModels = lightModels else {
      return
    }

    let viewModels = lightModels.map { LightViewModel(model: $0) }
    lightsView.setup(with: viewModels)
  }

  private func handleLightTap(lightID: String) {
    guard let lightModel = dataSource.lightModels?.first(where: {$0.id == lightID }) else {
      return
    }

    let newStatus: LightModel.Status = {
      switch lightModel.status {
      case .on:
        return .off
      case .off:
        return .on
      }
    }()

    LightsManager.setStatus(newStatus, lightID: lightID, dataSource: dataSource)
  }
}
