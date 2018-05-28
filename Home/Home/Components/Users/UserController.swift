//
//  UserController.swift
//  Home
//
//  Created by Sebastien Villar on 5/6/18.
//  Copyright © 2018 -. All rights reserved.
//

import Foundation

class UserController {

  lazy var userView = UserView(tapHandler: { [weak self] in
    self?.handleTap()
  })

  // MARK: - Public

  init(dataSource: DataSource) {
    self.dataSource = dataSource

    // Register changes
    dataSource.subscribeToChanges(for: [.users, .user], block: DataSource.ChangeBlock(block: { [weak self] in
      self?.handleUserModelChange(userModel: dataSource.userModel, usersModel: dataSource.usersModel)
    }))
  }

  // MARK: - Private

  private let dataSource: DataSource

  private func handleUserModelChange(userModel: UserModel?, usersModel: UsersModel?) {
    guard let userModel = userModel, let usersModel = usersModel else {
      return
    }

    userView.setup(with: UserViewModel(userModel: userModel, usersModel: usersModel))
  }

  private func handleTap() {
    guard let userModel = dataSource.userModel else {
      return
    }

    let newValues: (awayMethod: UserModel.AwayMethod, awayValue: UserModel.AwayValue?) = {
      switch userModel.awayMethod {
      case .auto:
        return (.manual, .home)
      case .manual:
        switch userModel.awayValue {
        case .home:
          return (.manual, .away)
        case .away:
          return (.auto, nil)
        }
      }
    }()

    UsersManager.setUserAwayMethod(newValues.awayMethod, awayValue: newValues.awayValue, dataSource: dataSource)
  }
}
