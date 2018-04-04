//
//  UIFont+Palette.swift
//  Home
//
//  Created by Sebastien Villar on 5/6/18.
//  Copyright © 2018 -. All rights reserved.
//

import Foundation
import UIKit

enum FontWeight {
  case regular
}

extension UIFont {
  static func interUI(size: CGFloat, weight: FontWeight) -> UIFont {
    switch weight {
    case .regular:
      return UIFont(name: "InterUI-Regular", size: size)!
    }
  }
}
