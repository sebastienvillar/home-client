//
//  SettingsHeaderView.swift
//  Home
//
//  Created by Sebastien Villar on 5/29/18.
//  Copyright © 2018 -. All rights reserved.
//

import Foundation
import UIKit

class SettingsHeaderView: UITableViewHeaderFooterView {

  static let identifier = "SettingsHeaderView"
  static let height: CGFloat = 50

  private struct Constants {
    static let paddingBottom: CGFloat = 7
  }

  // MARK: - Public

  override init(reuseIdentifier: String?) {
    super.init(reuseIdentifier: reuseIdentifier)

    addSubview(label)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func setup(with title: String) {
    label.text = title.uppercased()
  }

  // MARK: - Super overrides

  override func sizeThatFits(_ size: CGSize) -> CGSize {
    return CGSize(width: size.width, height: SettingsHeaderView.height)
  }

  override func layoutSubviews() {
    super.layoutSubviews()

    label.sizeToFit()
    label.frame = CGRect(
      x: layoutMargins.left,
      y: height - label.height - Constants.paddingBottom,
      width: width,
      height: label.height
    )
  }

  // MARK: - Private

  let label: UILabel = {
    let label = UILabel()
    label.textColor = UIColor.foregroundWhite.withAlphaComponent(0.5)
    label.font = .interUI(size: 12, weight: .regular)
    return label
  }()
}
