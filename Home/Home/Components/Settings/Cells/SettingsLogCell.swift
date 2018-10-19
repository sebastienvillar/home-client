//
//  SettingsLogCell.swift
//  Home
//
//  Created by Sebastien Villar on 10/19/18.
//  Copyright © 2018 -. All rights reserved.
//

import Foundation
import UIKit

class SettingsLogCell: SettingsBaseCell {

  // MARK: - Public

  static let identifier = "SettingsLogCell"

  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func setup(with model: SettingsLogCellModel) {
    textLabel?.text = model.title
  }
}
