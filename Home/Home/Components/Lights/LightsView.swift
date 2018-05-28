//
//  LightsView.swift
//  Home
//
//  Created by Sebastien Villar on 5/28/18.
//  Copyright © 2018 -. All rights reserved.
//

import Foundation
import UIKit

class LightsView: UIView {

  private struct Constants {
    static let horizontalMargin: CGFloat = 56
    static let verticalMargin: CGFloat = 30
  }

  // MARK: - Public

  init(tapHandler: @escaping (_ lightID: String) -> Void) {
    self.tapHandler = tapHandler

    super.init(frame: .zero)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func setup(with viewModels: [LightViewModel]) {
    lightViews.forEach { $0.removeFromSuperview() }
    lightViews = viewModels.map { model in
      let view = LightView(tapHandler: { [weak self] in
        self?.tapHandler(model.id)
      })
      view.setup(with: model)
      return view
    }

    lightViews.forEach { self.addSubview($0) }
    setNeedsLayout()
  }

  // MARK: - Super overrides

  override func layoutSubviews() {
    super.layoutSubviews()

    var x: CGFloat = 0
    var y: CGFloat = 0

    lightViews.forEach { view in
      view.sizeToFit()

      if x + view.width > width {
        x = 0
        y += Constants.verticalMargin
      }

      view.frame = CGRect(
        x: x,
        y: 0,
        width: view.width,
        height: view.height
      )

      x = view.right + Constants.horizontalMargin
    }
  }

  override func sizeThatFits(_ size: CGSize) -> CGSize {
    guard let lightSize = lightViews.first?.sizeThatFits(size) else {
      return .zero
    }

    let totalWidth = CGFloat(lightViews.count) * ceil(lightSize.width) + CGFloat(lightViews.count - 1) * Constants.horizontalMargin
    let lineCount = ceil(totalWidth / size.width)
    let height = lineCount * ceil(lightSize.height) + (lineCount - 1) * Constants.verticalMargin
    return CGSize(width: size.width, height: height)
  }

  // MARK: - Private

  private var lightViews = [LightView]()
  private let tapHandler: (String) -> Void
}

