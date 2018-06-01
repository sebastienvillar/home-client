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
  let homeLatitude: Double
  let homeLongitude: Double
  let homeRadius: Double
  let user: String

  init() {
    let url = Bundle.main.url(forResource: "config", withExtension: "json")!
    let data = try! Data(contentsOf: url)
    let model = try! JSONDecoder().decode(Config.self, from: data)
    self.homeIP = model.homeIP
    self.homeLatitude = model.homeLatitude
    self.homeLongitude = model.homeLongitude
    self.homeRadius = model.homeRadius
    self.user = model.user
  }
}
