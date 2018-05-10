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
    case users
    case user
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

  var usersModel: UsersModel? {
    didSet {
      notifyOfChange(for: .users)
    }
  }

  var userModel: UserModel? {
    didSet {
      notifyOfChange(for: .user)
    }
  }

  // MARK: - Public

  func refresh(completion: @escaping (_ success: Bool) -> Void) {
    let group = DispatchGroup()
    var success = true
    let handler = { (aSuccess: Bool) in
      success = success && aSuccess
      group.leave()
    }

    group.enter()
    refreshThermostat(completion: handler)
    group.enter()
    refreshUsers(completion: handler)
    group.enter()
    refreshUser(completion: handler)

    group.notify(queue: .main) {
      completion(success)
    }
  }

  func subscribeToChange(for key: ChangeKey, block: ChangeBlock) {
    var blocks = subscribedBlocks[key] ?? [ChangeBlock]()
    blocks.append(block)
    subscribedBlocks[key] = blocks
    block.block()
  }

  func subscribeToChanges(for keys: [ChangeKey], block: ChangeBlock) {
    keys.forEach { key in
      var blocks = subscribedBlocks[key] ?? [ChangeBlock]()
      blocks.append(block)
      subscribedBlocks[key] = blocks
    }
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

  private func refreshThermostat(completion: @escaping (_ success: Bool) -> Void) {
    ThermostatApi.get { response in
      DispatchQueue.main.async {
        switch response {
        case .success(let thermostatModel):
          self.thermostatModel = thermostatModel
          completion(true)
        case .failure:
          completion(false)
        }
      }
    }
  }

  private func refreshUsers(completion: @escaping (_ success: Bool) -> Void) {
    UsersApi.getUsers { response in
      DispatchQueue.main.async {
        switch response {
        case .success(let usersModel):
          self.usersModel = usersModel
          completion(true)
        case .failure:
          completion(false)
        }
      }
    }
  }

  private func refreshUser(completion: @escaping (_ success: Bool) -> Void) {
    UsersApi.getUser { response in
      DispatchQueue.main.async {
        switch response {
        case .success(let userModel):
          self.userModel = userModel
          completion(true)
        case .failure:
          completion(false)
        }
      }
    }
  }
}
