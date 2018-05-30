//
//  EasyTappingButton.swift
//  Home
//
//  Created by Sebastien Villar on 5/29/18.
//  Copyright © 2018 -. All rights reserved.
//

import Foundation
import UIKit

class EasyTappingButton: UIButton {

  private struct Constants {
    static let minTapSize = CGSize(width: 44, height: 44)
  }

  // MARK: - Super overrides

  override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
    let insetX = max(0, (Constants.minTapSize.width - bounds.size.width) / 2)
    let insetY = max(0, (Constants.minTapSize.height - bounds.size.height) / 2)
    return bounds.insetBy(dx: -insetX, dy: -insetY).contains(point)
  }
}
