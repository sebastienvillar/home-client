//
//  RootModel.swift
//  Home
//
//  Created by Sebastien Villar on 5/27/18.
//  Copyright © 2018 -. All rights reserved.
//

import Foundation

struct RootModel: Decodable, Equatable {

  // MARK: - Public

  let user: UserModel
  let users: UsersModel
  let thermostat: ThermostatModel
  let lights: [LightModel]
}
