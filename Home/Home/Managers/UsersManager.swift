//
//  UsersManager.swift
//  Home
//
//  Created by Sebastien Villar on 5/9/18.
//  Copyright © 2018 -. All rights reserved.
//

import Foundation
import UIKit

class UsersManager {

  static func setUserAwayMethod(_ awayMethod: UserModel.AwayMethod, awayValue: UserModel.AwayValue?, dataSource: DataSource) {
    guard var userModel = dataSource.userModel else {
      return
    }

    userModel.awayMethod = awayMethod
    userModel.keysToEncode = [UserModel.CodingKeys.awayMethod]
    if let awayValue = awayValue {
      userModel.awayValue = awayValue
      userModel.keysToEncode.append(UserModel.CodingKeys.awayValue)
    }

    dataSource.userModel = userModel

    UsersApi.patchUser(model: userModel) { response in
      switch response {
      case .success:
        break
      case .failure:
        break
      }
    }
  }
}
