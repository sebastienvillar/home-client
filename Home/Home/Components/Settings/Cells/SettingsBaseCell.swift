//
//  SettingsBaseCell.swift
//  Home
//
//  Created by Sebastien Villar on 10/19/18.
//  Copyright © 2018 -. All rights reserved.
//

import Foundation
import UIKit

class SettingsBaseCell: UITableViewCell {

  // MARK: - Public

  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)

    textLabel?.font = .interUI(size: 17, weight: .regular)
    textLabel?.textColor = .foregroundWhite

    backgroundColor = .backgroundLightGray
    tintColor = .foregroundWhite
    
    selectionStyle = .none
  }

  override func setHighlighted(_ highlighted: Bool, animated: Bool) {
    super.setHighlighted(highlighted, animated: animated)

    textLabel?.textColor = highlighted ? UIColor.foregroundWhite.withAlphaComponent(0.6) : UIColor.foregroundWhite
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
