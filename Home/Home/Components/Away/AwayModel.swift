//
//  AwayModel.swift
//  Home
//
//  Created by Sebastien Villar on 5/6/18.
//  Copyright © 2018 -. All rights reserved.
//

import Foundation

struct AwayModel: Decodable {

  enum Method: String, Decodable {
    case auto
    case manual
  }

  enum Value: String, Decodable {
    case away
    case home
  }

  let method: Method
  let value: Value
}
