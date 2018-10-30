//
//  LightBrightnessView.swift
//  Home
//
//  Created by Sebastien Villar on 10/19/18.
//  Copyright © 2018 -. All rights reserved.
//

import Foundation
import UIKit

class LightBrightnessView: UIView {

  private struct Constants {
    static let barBorderWidth: CGFloat = 5
    static let barCornerRadius: CGFloat = 10
    static let barInnerBorderCornerRadius: CGFloat = 6
    static let barInnerBorderWidth: CGFloat = 10
    static let barHorizontalMargin: CGFloat = 100
    static let barVerticalMargin: CGFloat = 80
    static let maxPanDistance: CGFloat = 300
  }

  // MARK: - Public

  enum BrightnessChange {
    case changed(level: Float)
    case canceled(initialLevel: Float)
    case ended(level: Float)
  }

  let barView = UIView()

  // MARK: -

  init(brightnessChangeHandler: @escaping ((BrightnessChange) -> Void)) {
    self.brightnessChangeHandler = brightnessChangeHandler
    super.init(frame: .zero)

    // Views
    backgroundColor = .backgroundDimming

    barView.layer.borderColor = UIColor.foregroundWhite.cgColor
    barView.layer.borderWidth = Constants.barBorderWidth
    barView.layer.cornerRadius = Constants.barCornerRadius
    barView.clipsToBounds = true
    addSubview(barView)

    barInnerBorderView.layer.cornerRadius = Constants.barInnerBorderCornerRadius
    barInnerBorderView.clipsToBounds = true
    barView.addSubview(barInnerBorderView)

    barColoredView.backgroundColor = UIColor.foregroundWhite
    barInnerBorderView.addSubview(barColoredView)

    // Recognizers
    let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
    addGestureRecognizer(tapRecognizer)

    let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
    addGestureRecognizer(panRecognizer)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func setup(brightnessRatio: Float) {
    self.brightnessRatio = CGFloat(brightnessRatio)

    setNeedsLayout()
  }

  // MARK: - Super overrides

  override func layoutSubviews() {
    super.layoutSubviews()

    // Bar
    if barView.transform == .identity {
      barView.frame = CGRect(
        x: Constants.barHorizontalMargin,
        y: Constants.barVerticalMargin,
        width: width - 2 * Constants.barHorizontalMargin,
        height: height - 2 * Constants.barVerticalMargin
      )
    }

    // Bar inner border
    barInnerBorderView.frame = CGRect(
      x: Constants.barInnerBorderWidth,
      y: Constants.barInnerBorderWidth,
      width: barView.width - 2 * Constants.barInnerBorderWidth,
      height: barView.height - 2 * Constants.barInnerBorderWidth
    )

    // Bar color
    barColoredView.frame = CGRect(
      x: 0,
      y: barInnerBorderView.height * (1 - brightnessRatio),
      width: barInnerBorderView.width,
      height: barInnerBorderView.height * brightnessRatio
    )
  }

  // MARK: - Private

  private let barInnerBorderView = UIView()
  private let barColoredView = UIView()
  private var brightnessRatio: CGFloat = 1
  private let brightnessChangeHandler: ((BrightnessChange) -> Void)
  private var startPanBrightnessRatio: CGFloat?
  private var startPanLocation: CGPoint?

  // MARK: Handlers

  @objc private func handleTap(_ recognizer: UITapGestureRecognizer) {
    brightnessChangeHandler(.canceled(initialLevel: Float(brightnessRatio)))
  }

  @objc private func handlePan(_ recognizer: UIPanGestureRecognizer) {
    switch recognizer.state {
    case .began:
      startPanBrightnessRatio = brightnessRatio
      startPanLocation = recognizer.location(in: self)

    case .changed, .ended:
      guard let startLocation = startPanLocation, let startBrightnessRatio = startPanBrightnessRatio else {
        assertionFailure("Missing location/brightness")
        return
      }

      let newLocation = recognizer.location(in: self)
      let yMin = startLocation.y - Constants.maxPanDistance * (1 - startBrightnessRatio)
      let yMax = startLocation.y + Constants.maxPanDistance * startBrightnessRatio
      let y = min(max(newLocation.y, yMin), yMax)
      let brightnessRatio = 1 - ((y - yMin) / (yMax - yMin))

      if recognizer.state == .changed {
        brightnessChangeHandler(.changed(level: Float(brightnessRatio)))
      }
      else if recognizer.state == .ended {
        startPanBrightnessRatio = nil
        startPanLocation = nil
        brightnessChangeHandler(.ended(level: Float(brightnessRatio)))
      }

    case .cancelled, .failed:
      if let startBrightnessRatio = startPanBrightnessRatio {
        brightnessChangeHandler(.canceled(initialLevel: Float(startBrightnessRatio)))
      }

      startPanBrightnessRatio = nil
      startPanLocation = nil

    case .possible:
      break
    }
  }
}
