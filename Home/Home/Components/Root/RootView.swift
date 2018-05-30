//
//  RootView.swift
//  Home
//
//  Created by Sebastien Villar on 04/04/2018.
//  Copyright © 2018 -. All rights reserved.
//

import Foundation
import UIKit

class RootView: UIScrollView {

  private struct Constants {
    static let paddingHorizontal: CGFloat = 35
    static let paddingVertical: CGFloat = 23
    static let interMarginVertical: CGFloat = 47
    static let settingsMarginRight: CGFloat = 36
    static let settingsMarginBottom: CGFloat = 28
  }

  // MARK: - Public

  enum Status {
    case loading
    case offline
    case ready
  }

  struct ViewCollection {
    let thermostatTemperatureView: UIView
    let thermostatTemperatureAdjustmentView: UIView
    let userView: UIView
    let lightsView: UIView
    let settingsButton: UIButton

    var allViews: [UIView] {
      return [
        thermostatTemperatureView,
        thermostatTemperatureAdjustmentView,
        userView,
        lightsView,
        settingsButton,
      ]
    }
  }

  init() {
    super.init(frame: .zero)

    backgroundColor = .backgroundGray
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func setup(with status: Status) {
    self.status = .loading
    setNeedsLayout()
  }

  func setup(with viewCollection: ViewCollection) {
    self.viewCollection?.allViews.forEach { $0.removeFromSuperview() }
    self.viewCollection = viewCollection
    viewCollection.allViews.forEach { addSubview($0) }
    setNeedsLayout()
  }

  // MARK: - Super overrides

  override func layoutSubviews() {
    super.layoutSubviews()

    guard let viewCollection = viewCollection else {
      return
    }

    // Thermostat temperature
    viewCollection.thermostatTemperatureView.sizeToFit()
    viewCollection.thermostatTemperatureView.frame = CGRect(
      x: Constants.paddingHorizontal,
      y: Constants.paddingVertical,
      width: viewCollection.thermostatTemperatureView.width,
      height: viewCollection.thermostatTemperatureView.height
    )

    // Away
    viewCollection.userView.sizeToFit()
    viewCollection.userView.frame = CGRect(
      x: width - Constants.paddingHorizontal - viewCollection.userView.width,
      y: Constants.paddingVertical,
      width: viewCollection.userView.width,
      height: viewCollection.userView.height
    )

    // Lights view
    let lightsViewSize = viewCollection.lightsView.sizeThatFits(CGSize(width: width - 2 * Constants.paddingHorizontal, height: .greatestFiniteMagnitude))
    viewCollection.lightsView.frame = CGRect(
      x: Constants.paddingHorizontal,
      y: viewCollection.userView.bottom + Constants.interMarginVertical,
      width: lightsViewSize.width,
      height: lightsViewSize.height
    )

    // Thermostat temperature adjustment
    viewCollection.thermostatTemperatureAdjustmentView.sizeToFit()
    viewCollection.thermostatTemperatureAdjustmentView.frame = CGRect(
      x: 0,
      y: viewCollection.lightsView.bottom + Constants.interMarginVertical,
      width: width,
      height: viewCollection.thermostatTemperatureAdjustmentView.height
    )

    // Settings icon
    viewCollection.settingsButton.sizeToFit()
    viewCollection.settingsButton.frame = CGRect(
      x: width - Constants.settingsMarginRight - viewCollection.settingsButton.width,
      y: height - Constants.settingsMarginBottom - viewCollection.settingsButton.height,
      width: viewCollection.settingsButton.width,
      height: viewCollection.settingsButton.height
    )
  }

  // MARK: - Private

  private var viewCollection: ViewCollection?
  private var status: Status = .loading

  let button = UIButton()
}
