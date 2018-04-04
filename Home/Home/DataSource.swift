//
//  DataSource.swift
//  Home
//
//  Created by Sebastien Villar on 04/04/2018.
//  Copyright © 2018 -. All rights reserved.
//

import Foundation

class DataSource {

  enum ChangeKey {
    case thermostat
    case away
  }

  struct ChangeBlock: Equatable {
    fileprivate let block: () -> Void
    private let id = UUID()

    init(block: @escaping () -> Void) {
      self.block = block
    }

    static func ==(lhs: ChangeBlock, rhs: ChangeBlock) -> Bool {
      return lhs.id == rhs.id
    }
  }

  // Models
  var thermostatModel: ThermostatModel? {
    didSet {
      notifyOfChange(for: .thermostat)
    }
  }

  var awayModel: AwayModel? {
    didSet {
      notifyOfChange(for: .away)
    }
  }

  // MARK: - Public

  func refresh(completion: (_ success: Bool) -> Void) {
    thermostatModel = ThermostatModel(temperature: 30, targetTemperature: 35, mode: .heat, status: .on)
    awayModel = AwayModel(method: .auto, value: .away)
//    thermostatModel = root?.object(at: "thermostat")
    completion(true)
  }

  func subscribeToChange(for key: ChangeKey, block: ChangeBlock) {
    var blocks = subscribedBlocks[key] ?? [ChangeBlock]()
    blocks.append(block)
    subscribedBlocks[key] = blocks
    block.block()
  }

  func unsubscribeFromChange(for key: ChangeKey, block: ChangeBlock) {
    if var blocks = subscribedBlocks[key] {
      blocks = blocks.filter { $0 != block }
      subscribedBlocks[key] = blocks
    }
  }

  // MARK: - Private

  private var subscribedBlocks = [ChangeKey: [ChangeBlock]]()

  private func notifyOfChange(for key: ChangeKey) {
    subscribedBlocks[key]?.forEach { $0.block() }
  }

}
