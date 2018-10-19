//
//  NavigationBar.swift
//  Home
//
//  Created by Sebastien Villar on 10/19/18.
//  Copyright © 2018 -. All rights reserved.
//

import Foundation
import UIKit

class NavigationBarView: UIView {

  private struct Constants {
    static let height: CGFloat = 47
  }

  // MARK: - Public

  var onCancel: (() -> Void)?

  init() {
    super.init(frame: .zero)

    cancelButton.addTarget(self, action: #selector(handleCancelTap), for: .touchUpInside)
    addSubview(cancelButton)

    backgroundColor = .backgroundGray
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Super overrides

  override func layoutSubviews() {
    super.layoutSubviews()

    cancelButton.sizeToFit()
    cancelButton.frame = CGRect(
      x: layoutMargins.left,
      y: layoutMargins.left,
      width: cancelButton.width,
      height: cancelButton.height
    )
  }

  override func sizeThatFits(_ size: CGSize) -> CGSize {
    return CGSize(width: width, height: Constants.height)
  }

  // MARK: - Private

  private let cancelButton = CancelButton()

  // MARK: Handlers

  @objc private func handleCancelTap() {
    onCancel?()
  }
}
