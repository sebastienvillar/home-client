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
    static let adjustmentViewMarginTop: CGFloat = 20
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
    let awayView: UIView

    var allViews: [UIView] {
      return [
        thermostatTemperatureView,
        thermostatTemperatureAdjustmentView,
        awayView,
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
    viewCollection.awayView.sizeToFit()
    viewCollection.awayView.frame = CGRect(
      x: width - Constants.paddingHorizontal - viewCollection.awayView.width,
      y: Constants.paddingVertical,
      width: viewCollection.awayView.width,
      height: viewCollection.awayView.height
    )

    // Thermostat temperature adjustment
    viewCollection.thermostatTemperatureAdjustmentView.sizeToFit()
    viewCollection.thermostatTemperatureAdjustmentView.frame = CGRect(
      x: 0,
      y: viewCollection.awayView.bottom + Constants.adjustmentViewMarginTop,
      width: width,
      height: viewCollection.thermostatTemperatureAdjustmentView.height
    )
  }

  // MARK: - Private

  private var viewCollection: ViewCollection?
  private var status: Status = .loading

  let button = UIButton()
}
