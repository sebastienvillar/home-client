//
//  UserViewModel.swift
//  Home
//
//  Created by Sebastien Villar on 5/6/18.
//  Copyright © 2018 -. All rights reserved.
//

import Foundation

struct UserViewModel {

  // MARK: - Public

  enum HighlightType {
    case highlighted
    case semiHighlighted
    case none
  }

  var title: String {
    switch userModel.awayMethod {
    case .auto:
      return "Auto"
    case .manual:
      return userAwayValue
    }
  }

  var subtitle: String? {
    switch userModel.awayMethod {
    case .auto:
      return userAwayValue
    case .manual:
      return nil
    }
  }

  var highlightType: HighlightType {
    switch usersModel.awayValue {
    case .home:
      switch userModel.awayValue {
      case .home:
        return .highlighted
      case .away:
        return .semiHighlighted
      }
    case .away:
      return .none
    }
  }

  init(userModel: UserModel, usersModel: UsersModel) {
    self.userModel = userModel
    self.usersModel = usersModel
  }

  // MARK: - Private

  private let userModel: UserModel
  private let usersModel: UsersModel

  private var userAwayValue: String {
    switch userModel.awayValue {
    case .away:
      return "Away"
    case .home:
      return "Home"
    }
  }
}
