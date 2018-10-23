//
//  ThermostatCurrentTemperatureView.swift
//  Home
//
//  Created by Sebastien Villar on 04/04/2018.
//  Copyright © 2018 -. All rights reserved.
//

import Foundation
import UIKit

class ThermostatTemperatureView: UIView {

  private struct Constants {
    static let arrowMarginLeft: CGFloat = 7
    static let arrowMarginTop: CGFloat = -2
  }

  // MARK: - Public

  init() {
    super.init(frame: .zero)

    addSubview(label)
    addSubview(arrow)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func setup(with viewModel: ThermostatTemperatureViewModel) {
    label.text = viewModel.temperature
    arrow.isHidden = false
    switch viewModel.status {
    case .off:
      arrow.isHidden = true
    case .heating:
      arrow.transform = CGAffineTransform.identity.rotated(by: CGFloat(-Double.pi / 2))
    case .cooling:
      arrow.transform = CGAffineTransform.identity
    }

    setNeedsLayout()
  }

  // MARK: - Super overrides

  override func layoutSubviews() {
    super.layoutSubviews()

    // Label
    label.sizeToFit()
    label.frame = CGRect(
      x: 0,
      y: 0,
      width: label.width,
      height: label.height
    ).integral

    // Arrow
    arrow.frame = CGRect(
      x: Constants.arrowMarginLeft,
      y: label.bottom + Constants.arrowMarginTop,
      width: arrow.width,
      height: arrow.height
    )
  }

  override func sizeThatFits(_ size: CGSize) -> CGSize {
    let labelSize = label.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude))
    let arrowSize = arrow.frame.size

    return CGSize(
      width: max(labelSize.width, arrowSize.width),
      height: ceil(labelSize.height) + Constants.arrowMarginTop + arrowSize.height
    )
  }

  // MARK: - Private
  
  private var label: UILabel = {
    let label = UILabel()
    label.textColor = UIColor.foregroundWhite
    label.font = UIFont.interUI(size: 60, weight: .regular)
    return label
  }()

  private var arrow: UIImageView = {
    let imageView = UIImageView(image: UIImage(named: "arrow"))
    imageView.contentMode = .scaleAspectFill
    imageView.frame.size = CGSize(width: 16, height: 16)
    return imageView
  }()
}
