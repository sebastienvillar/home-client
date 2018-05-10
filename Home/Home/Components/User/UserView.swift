//
//  UserView.swift
//  Home
//
//  Created by Sebastien Villar on 5/6/18.
//  Copyright © 2018 -. All rights reserved.
//

import Foundation
import UIKit

class UserView: UIView {

  private struct Constants {
    static let size = CGSize(width: 88, height: 88)
    static let circleBorderWidth: CGFloat = 3
    static let titleMarginBottom: CGFloat = 3
  }

  // MARK: - Public

  init(tapHandler: @escaping () -> Void) {
    self.tapHandler = tapHandler
    
    super.init(frame: .zero)

    addSubview(circleView)
    addSubview(titleLabel)
    addSubview(subtitleLabel)

    let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleCircleTapped))
    circleView.addGestureRecognizer(tapRecognizer)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func setup(with viewModel: UserViewModel) {
    titleLabel.text = viewModel.title
    subtitleLabel.text = viewModel.subtitle
    subtitleLabel.isHidden = viewModel.subtitle == nil

    switch viewModel.highlightType {
    case .none:
      circleView.layer.borderColor = UIColor.foregroundLightGray.cgColor
    case .semiHighlighted:
      circleView.layer.borderColor = UIColor.foregroundGreen.withAlphaComponent(0.3).cgColor
    case .highlighted:
      circleView.layer.borderColor = UIColor.foregroundGreen.cgColor
    }

    setNeedsLayout()
  }

  // MARK: - Super overrides

  override func layoutSubviews() {
    super.layoutSubviews()

    let titleLabelSize = titleLabel.sizeThatFits(bounds.size)
    let subtitleLabelSize = subtitleLabel.sizeThatFits(bounds.size)

    let labelsHeight: CGFloat = {
      if subtitleLabel.isHidden {
        return ceil(titleLabelSize.height)
      }
      else {
        let titleHeight = ceil(titleLabelSize.height)
        let subtitleHeight = ceil(subtitleLabelSize.height)
        return titleHeight + Constants.titleMarginBottom + subtitleHeight
      }
    }()

    // Title
    titleLabel.frame = CGRect(
      x: (width - titleLabelSize.width) / 2,
      y: (height - labelsHeight) / 2,
      width: titleLabelSize.width,
      height: titleLabelSize.height
    ).integral

    // Subtitle
    if !subtitleLabel.isHidden {
      subtitleLabel.frame = CGRect(
        x: (width - subtitleLabel.width) / 2,
        y: height - (height - labelsHeight) / 2 - subtitleLabelSize.height,
        width: subtitleLabelSize.width,
        height: subtitleLabelSize.height
      ).integral
    }

    // Circle
    circleView.frame = bounds
    circleView.layer.cornerRadius = ceil(bounds.width / 2)
  }

  override func sizeThatFits(_ size: CGSize) -> CGSize {
    return Constants.size
  }

  // MARK: - Private

  private let tapHandler: () -> Void

  private var titleLabel: UILabel = {
    let label = UILabel()
    label.textColor = UIColor.foregroundWhite
    label.font = UIFont.interUI(size: 20, weight: .regular)
    return label
  }()

  private var subtitleLabel: UILabel = {
    let label = UILabel()
    label.textColor = UIColor.foregroundGray
    label.font = UIFont.interUI(size: 15, weight: .regular)
    return label
  }()

  private var circleView: UIView = {
    let view = UIView()
    view.layer.borderColor = UIColor.foregroundGreen.cgColor
    view.layer.borderWidth = Constants.circleBorderWidth
    return view
  }()

  @objc private func handleCircleTapped() {
    tapHandler()
  }
}

