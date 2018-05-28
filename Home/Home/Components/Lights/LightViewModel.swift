//
//  LightViewModel.swift
//  Home
//
//  Created by Sebastien Villar on 5/28/18.
//  Copyright © 2018 -. All rights reserved.
//

import Foundation

struct LightViewModel {

  // MARK: - Public

  enum Status {
    case on
    case off
  }

  var status: Status {
    switch model.status {
    case .on:
      return .on
    case .off:
      return .off
    }
  }

  var id: String {
    return model.id
  }

  var title: String {
    return model.name
  }

  init(model: LightModel) {
    self.model = model
  }

  // MARK: - Private

  private let model: LightModel
}
