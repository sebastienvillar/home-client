//
//  LightsController.swift
//  Home
//
//  Created by Sebastien Villar on 5/28/18.
//  Copyright © 2018 -. All rights reserved.
//

import Foundation
import UIKit

class LightsController {

  private struct Constants {
    static let brightnessAnimationDuration: TimeInterval = 0.1
    static let brightnessMinimumScale: CGFloat = 0.6
    static let brightnessDebounce: TimeInterval = 0.2
  }

  lazy var lightsView = LightsView(tapHandler: { [weak self] lightID in
    self?.handleLightTap(lightID: lightID)
    }, brightnessActivateHandler: { [weak self] lightID in
    self?.handleBrightnessActivated(lightID: lightID)
  })

  lazy var brightnessView = LightBrightnessView(brightnessChangeHandler: { [weak self] brightnessChange in
    self?.handleBrightnessChange(brightnessChange: brightnessChange)
  })

  // MARK: - Public

  init(dataSource: DataSource) {
    self.dataSource = dataSource
    self.brightnessView.isHidden = true
    self.brightnessView.barView.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)

    // Register changes
    dataSource.subscribeToChanges(for: [.lights], block: DataSource.ChangeBlock(block: { [weak self] in
      self?.handleLightModelsChange(lightModels: dataSource.lightModels)
    }))
  }

  // MARK: - Private

  private let dataSource: DataSource
  private var brightnessChangeLightID: String?
  private let brightnessDebouncer = Debouncer(duration: Constants.brightnessDebounce)

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

  private func handleBrightnessActivated(lightID: String) {
    guard let lightModel = dataSource.lightModels?.first(where: { $0.id == lightID }) else {
      assertionFailure("Missing light model")
      return
    }

    brightnessChangeLightID = lightID
    brightnessView.setup(brightness: Float(fromBrightnessScale: lightModel.brightness))
    updateBrightnessViewVisibility(on: true)
  }

  private func handleBrightnessChange(brightnessChange: LightBrightnessView.BrightnessChange) {
    guard let lightID = brightnessChangeLightID else {
      assertionFailure("Missing light lightID")
      return
    }

    switch brightnessChange {
    case .changed(let level), .canceled(let level), .ended(let level):
      brightnessView.setup(brightness: level)
      brightnessDebouncer.debounce { [weak self] in
        if let `self` = self {
          LightsManager.setBrightness(level.toBrightnessScale(), lightID: lightID, dataSource: self.dataSource)
        }
      }

      switch brightnessChange {
      case .ended, .canceled:
        brightnessChangeLightID = nil
        updateBrightnessViewVisibility(on: false)
      case .changed:
        break
      }
    }
  }

  private func updateBrightnessViewVisibility(on: Bool) {
    let update = { [weak self] (_ on: Bool) in
      let scale = on ? 1 : Constants.brightnessMinimumScale
      self?.brightnessView.alpha = on ? 1 : 0
      self?.brightnessView.barView.transform = CGAffineTransform(scaleX: scale, y: scale)
    }

    brightnessView.isHidden = false
    update(!on)

    UIView.animate(withDuration: Constants.brightnessAnimationDuration, delay: 0, options: .curveEaseOut, animations: {
      update(on)
    }) { _ in
      self.brightnessView.isHidden = !on
    }
  }
}

private extension Float {
  func toBrightnessScale() -> Int {
    return 1 + Int(roundf(self * 253))
  }

  init(fromBrightnessScale scale: Int) {
    self = (Float(scale - 1) / 253)
  }
}
