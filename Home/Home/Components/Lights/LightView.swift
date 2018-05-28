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
    static let imageBottomMargin: CGFloat = 10
    static let titleFont = UIFont.interUI(size: 16, weight: .regular)
  }

  // MARK: - Public

  init(tapHandler: @escaping () -> Void) {
    self.tapHandler = tapHandler
    
    super.init(frame: .zero)

    addSubview(imageView)
    addSubview(titleLabel)

    let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
    addGestureRecognizer(tapRecognizer)

    clipsToBounds = false
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func setup(with viewModel: LightViewModel) {
    imageView.image = {
      switch viewModel.status {
      case .on:
        return UIImage(named: "light-on")
      case .off:
        return UIImage(named: "light-off")
      }
    }()

    titleLabel.text = viewModel.title
  }

  // MARK: - Super overrides

  override func layoutSubviews() {
    super.layoutSubviews()

    // Image
    imageView.sizeToFit()
    imageView.frame = CGRect(
      x: (width - imageView.width) / 2,
      y: 0,
      width: imageView.width,
      height: imageView.height
    ).integral

    // Title
    titleLabel.sizeToFit()
    titleLabel.frame = CGRect(
      x: (width - titleLabel.width) / 2,
      y: imageView.bottom + Constants.imageBottomMargin,
      width: titleLabel.width,
      height: titleLabel.height
    ).integral
  }

  override func sizeThatFits(_ size: CGSize) -> CGSize {
    let imageSize = imageView.sizeThatFits(size)
    let titleSize = titleLabel.sizeThatFits(size)
    return CGSize(
      width: ceil(imageSize.width),
      height: ceil(imageSize.height) + Constants.imageBottomMargin + ceil(titleSize.height)
    )
  }

  // MARK: - Private

  private let imageView = UIImageView()
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.font = Constants.titleFont
    label.textColor = UIColor.foregroundWhite
    label.textAlignment = .center
    return label
  }()

  private let tapHandler: () -> Void

  // MARK: Handlers

  @objc private func handleTap() {
    tapHandler()
  }
}
