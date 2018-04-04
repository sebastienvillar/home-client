//
//  AwayViewModel.swift
//  Home
//
//  Created by Sebastien Villar on 5/6/18.
//  Copyright © 2018 -. All rights reserved.
//

import Foundation

struct AwayViewModel {

  // MARK: - Public

  var title: String {
    switch model.method {
    case .auto:
      return "Auto"
    case .manual:
      return value
    }
  }

  var subtitle: String? {
    switch model.method {
    case .auto:
      return value
    case .manual:
      return nil
    }
  }

  init(model: AwayModel) {
    self.model = model
  }

  // MARK: - Private

  private let model: AwayModel

  private var value: String {
    switch model.value {
    case .away:
      return "Away"
    case .home:
      return "Home"
    }
  }
}
