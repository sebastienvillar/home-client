//
//  LightView.swift
//  Home
//
//  Created by Sebastien Villar on 5/28/18.
//  Copyright © 2018 -. All rights reserved.
//

import Foundation
import UIKit

class LightView: UIView {

  private struct Constants {
    static let iconBottomMargin: CGFloat = 10
    static let titleFont = UIFont.interUI(size: 16, weight: .regular)
    static let minPressDuration: TimeInterval = 0.2
    static let maxPressDistance: CGFloat = 70
  }

  // MARK: - Public

  private(set) var viewModel: LightViewModel?

  init() {
    super.init(frame: .zero)

    addSubview(iconView)
    addSubview(titleLabel)

    let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
    addGestureRecognizer(tapRecognizer)

    let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
    longPressRecognizer.minimumPressDuration = Constants.minPressDuration
    addGestureRecognizer(longPressRecognizer)

    clipsToBounds = false
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func setup(with viewModel: LightViewModel, tapHandler: @escaping () -> Void, brightnessActivateHandler: @escaping () -> Void) {
    self.tapHandler = tapHandler
    self.brightnessActivateHandler = brightnessActivateHandler

    guard viewModel != self.viewModel else {
      return
    }

    iconView.setup(on: viewModel.status == .on, brightness: viewModel.brightness)
    titleLabel.text = viewModel.title
    self.viewModel = viewModel

    setNeedsLayout()
  }

  // MARK: - Super overrides

  override func layoutSubviews() {
    super.layoutSubviews()

    // Image
    iconView.sizeToFit()
    iconView.frame = CGRect(
      x: (width - iconView.width) / 2,
      y: 0,
      width: iconView.width,
      height: iconView.height
    ).integral

    // Title
    titleLabel.sizeToFit()
    titleLabel.frame = CGRect(
      x: (width - titleLabel.width) / 2,
      y: iconView.bottom + Constants.iconBottomMargin,
      width: titleLabel.width,
      height: titleLabel.height
    ).integral
  }

  override func sizeThatFits(_ size: CGSize) -> CGSize {
    let iconSize = iconView.sizeThatFits(size)
    let titleSize = titleLabel.sizeThatFits(size)
    return CGSize(
      width: ceil(iconSize.width),
      height: ceil(iconSize.height) + Constants.iconBottomMargin + ceil(titleSize.height)
    )
  }

  // MARK: - Private

  private let iconView = IconView()
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.font = Constants.titleFont
    label.textColor = UIColor.foregroundWhite
    label.textAlignment = .center
    return label
  }()

  private var tapHandler: (() -> Void)?
  private var brightnessActivateHandler: (() -> Void)?
  private var startLongPressLocation: CGPoint?

  // MARK: Handlers

  @objc private func handleTap(_ recognizer: UITapGestureRecognizer) {
    tapHandler?()
  }

  @objc private func handleLongPress(_ recognizer: UILongPressGestureRecognizer) {
    switch recognizer.state {
    case .began:
      startLongPressLocation = recognizer.location(in: self)
      iconView.animatePressIndicator(on: true)

    case .ended:
      brightnessActivateHandler?()
      iconView.animatePressIndicator(on: false)

    case .cancelled, .failed:
      iconView.animatePressIndicator(on: false)

    case .changed:
      guard let startLocation = startLongPressLocation else {
        assertionFailure("Missing start location")
        return
      }

      let location = recognizer.location(in: self)
      let distance = sqrt(pow(location.x - startLocation.x, 2) + pow(location.y - startLocation.y, 2))

      if distance > Constants.maxPressDistance {
        // Cancel
        recognizer.isEnabled = false
        recognizer.isEnabled = true
      }

    case .possible:
      break
    }
  }
}

// MARK: -

private class IconView: UIView {
  private struct Constants {
    static let activatorInterPadding: CGFloat = 12
    static let activatorBorderWidth: CGFloat = 2
    static let activatorAnimationDuration: TimeInterval = 0.25
    static let activatorMaskRatio: CGFloat = 0.2
    static let activatorScaleRatio: CGFloat = 0.8
  }

  private let dimmedImageView = UIImageView()
  private let mainImageView = UIImageView()
  private var activatorViews: [UIView] = []
  private var brightness: CGFloat = 1

  init() {
    super.init(frame: .zero)

    dimmedImageView.image = UIImage(named: "light-dimmed")

    for _ in 0..<3 {
      let view = UIView()
      view.layer.borderWidth = Constants.activatorBorderWidth
      view.layer.borderColor = UIColor.foregroundWhite.cgColor
      view.isHidden = true
      view.clipsToBounds = true
      view.mask = UIView()
      view.mask?.backgroundColor = .black
      activatorViews.append(view)
      addSubview(view)
    }

    addSubview(dimmedImageView)
    addSubview(mainImageView)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func setup(on: Bool, brightness: CGFloat) {
    self.brightness = brightness

    if on {
      mainImageView.image = UIImage(named: "light-on")
      mainImageView.mask = mainImageView.mask ?? UIView()
      mainImageView.mask?.backgroundColor = .black
      dimmedImageView.isHidden = false
    }
    else {
      mainImageView.image = UIImage(named: "light-off")
      mainImageView.mask = nil
      dimmedImageView.isHidden = true
    }

    setNeedsLayout()
  }

  func animatePressIndicator(on: Bool) {
    let duration = TimeInterval(Double(Constants.activatorAnimationDuration) / Double(activatorViews.count))
    activatorViews.forEach { view in
      view.isHidden = false
      view.transform = .identity
    }

    if on {
      activatorViews.enumerated().forEach { object in
        let (index, view) = object
        view.alpha = 0

        let isLast = index == activatorViews.count - 1
        let hideDelay = duration / 2
        let delay = TimeInterval(Double(index) * Double(duration)) + (isLast ? hideDelay : 0)

        UIView.animate(withDuration: duration, delay: delay, options: .curveEaseOut, animations: {
          view.alpha = 1
        }) { _ in
          if index != self.activatorViews.count - 1 {
            UIView.animate(withDuration: duration, delay: hideDelay, options: .curveEaseOut, animations: {
              view.alpha = 0
            }, completion: nil)
          }
        }
      }
    }
    else {
      UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: {
        self.activatorViews.forEach { $0.alpha = 0 }
        self.activatorViews.last?.transform = CGAffineTransform.identity.scaledBy(x: Constants.activatorScaleRatio, y: Constants.activatorScaleRatio)
      }) { _ in
        self.activatorViews.forEach { $0.isHidden = true }
      }
    }
  }

  override func layoutSubviews() {
    super.layoutSubviews()

    // Image
    mainImageView.sizeToFit()
    mainImageView.mask?.frame = CGRect(
      x: 0,
      y: mainImageView.height * (1 - brightness),
      width: mainImageView.width,
      height:  mainImageView.height * brightness
    )

    // Dimmed image
    dimmedImageView.frame = mainImageView.frame

    // Activators
    activatorViews.enumerated().forEach { object in
      let (index, view) = object
      if view.transform == .identity {
        let dimension = width + Constants.activatorInterPadding * CGFloat(index + 1)
        view.frame.size = CGSize(width: dimension, height: dimension)
        view.center = center
        view.layer.cornerRadius = ceil(dimension / 2)
        view.mask?.frame = CGRect(
          x: 0,
          y: 0,
          width: view.width,
          height: view.height * (1 - Constants.activatorMaskRatio)
        )
      }
    }
  }

  override func sizeThatFits(_ size: CGSize) -> CGSize {
    return dimmedImageView.sizeThatFits(size)
  }
}
