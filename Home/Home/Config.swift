//
//  Config.swift
//  Home
//
//  Created by Sebastien Villar on 5/29/18.
//  Copyright © 2018 -. All rights reserved.
//

import Foundation

class Config: Decodable {
  static let shared = Config()

  let homeIP: String
  let user: String

  init() {
    let url = Bundle.main.url(forResource: "config", withExtension: "json")!
    let data = try! Data(contentsOf: url)
    let model = try! JSONDecoder().decode(Config.self, from: data)
    self.homeIP = model.homeIP
    self.user = model.user
  }
}
