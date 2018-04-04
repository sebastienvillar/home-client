//
//  UIView+Frame.swift
//  Home
//
//  Created by Sebastien Villar on 04/04/2018.
//  Copyright © 2018 -. All rights reserved.
//

import Foundation
import UIKit

extension UIView {

  var left: CGFloat {
    return frame.origin.x
  }

  var top: CGFloat {
    return frame.origin.y
  }

  var right: CGFloat {
    return left + width
  }

  var bottom: CGFloat {
    return top + height
  }

  var width: CGFloat {
    return bounds.size.width
  }

  var height: CGFloat {
    return bounds.size.height
  }

}
