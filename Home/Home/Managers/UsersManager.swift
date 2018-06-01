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

  static func setUserAwayMethod(_ awayMethod: UserModel.AwayMethod, awayValue: UserModel.AwayValue?, dataSource: DataSource, completion: (() -> Void)? = nil) {
    guard var userModel = dataSource.userModel, var usersModel = dataSource.usersModel else {
      return
    }

    userModel.awayMethod = awayMethod
    userModel.keysToEncode = [UserModel.CodingKeys.awayMethod]
    if let awayValue = awayValue {
      userModel.awayValue = awayValue
      userModel.keysToEncode.append(UserModel.CodingKeys.awayValue)

      // Let's assume I'm the only user so there's no UI glitch
      if awayValue == .away {
        usersModel.awayValue = .away
      }
    }

    guard dataSource.userModel != userModel || dataSource.usersModel != usersModel else {
      return
    }

    dataSource.userModel = userModel
    dataSource.usersModel = usersModel

    UserApi.patch(model: userModel) { response in
      DispatchQueue.main.async {
        switch response {
        case .success(let httpResponse, let model):
          dataSource.updateIfNeeded(with: httpResponse, model: model)
          completion?()
          break
        case .failure(let statusCode, let message):
          AlertController.shared.show(request: "Set userAwayMethod", statusCode: statusCode, message: message)
          completion?()
          break
        }
      }
    }
  }
}
