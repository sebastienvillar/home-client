//
//  SettingsModeCell.swift
//  Home
//
//  Created by Sebastien Villar on 5/29/18.
//  Copyright © 2018 -. All rights reserved.
//

import Foundation
import UIKit

class SettingsModeCell: UITableViewCell {

  // MARK: - Public

  static let identifier = "SettingsModeCell"

  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)

    backgroundColor = .backgroundLightGray
    selectionStyle = .none
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func setup(with model: SettingsModeCellModel) {
    textLabel?.text = model.title
    textLabel?.font = .interUI(size: 17, weight: .regular)
    textLabel?.textColor = .foregroundWhite
    accessoryType = model.checked ? .checkmark : .none
    tintColor = .foregroundWhite
  }
}
