//
//  CancelButton.swift
//  Home
//
//  Created by Sebastien Villar on 5/29/18.
//  Copyright © 2018 -. All rights reserved.
//

import Foundation
import UIKit

class CancelButton: EasyTappingButton {

  init() {
    super.init(frame: .zero)

    setImage(UIImage(named: "cross"), for: .normal)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
