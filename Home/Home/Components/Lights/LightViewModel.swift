//
//  LightViewModel.swift
//  Home
//
//  Created by Sebastien Villar on 5/28/18.
//  Copyright © 2018 -. All rights reserved.
//

import Foundation
import UIKit

struct LightViewModel: Equatable {

  // MARK: - Public

  enum Status: Equatable {
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

  var brightness: CGFloat {
    return CGFloat(model.brightness)
  }

  init(model: LightModel) {
    self.model = model
  }

  // MARK: - Private

  private let model: LightModel
}
