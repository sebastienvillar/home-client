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

    UserApi.patch(model: userModel) { response in
      DispatchQueue.main.async {
        switch response {
        case .success(let httpResponse, let model):
          dataSource.updateIfNeeded(with: httpResponse, model: model)
          break
        case .failure(let statusCode, let message):
          AlertController.shared.show(request: "Patch User", statusCode: statusCode, message: message)
          break
        }
      }
    }
  }
}
