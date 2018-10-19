//
//  SettingsModeCell.swift
//  Home
//
//  Created by Sebastien Villar on 5/29/18.
//  Copyright © 2018 -. All rights reserved.
//

import Foundation
import UIKit

class SettingsModeCell: SettingsBaseCell {

  // MARK: - Public

  static let identifier = "SettingsModeCell"

  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func setup(with model: SettingsModeCellModel) {
    textLabel?.text = model.title
    accessoryType = model.checked ? .checkmark : .none
  }
}
