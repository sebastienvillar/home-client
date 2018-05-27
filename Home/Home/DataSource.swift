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
      if oldValue != thermostatModel {
        notifyOfChange(for: .thermostat)
      }
    }
  }

  var usersModel: UsersModel? {
    didSet {
      if oldValue != usersModel {
        notifyOfChange(for: .users)
      }
    }
  }

  var userModel: UserModel? {
    didSet {
      if oldValue != userModel {
        notifyOfChange(for: .user)
      }
    }
  }

  // MARK: - Public

  func refresh(completion: ((_ success: Bool) -> Void)? = nil) {
    RootApi.get { response in
      DispatchQueue.main.async {
        switch response {
        case .success(let rootModel):
          self.userModel = rootModel.user
          self.usersModel = rootModel.users
          self.thermostatModel = rootModel.thermostat
          completion?(true)
        case .failure(let statusCode, let message):
          AlertController.shared.show(request: "Get Root", statusCode: statusCode, message: message)
          completion?(false)
        }
      }
    }
  }

  func updateIfNeeded(with response: HTTPURLResponse, model: RootModel?) {
    guard NetworkSession.shared.isLastResponse(response) else {
      return
    }

    guard let model = model else {
      return
    }

    userModel = model.user
    usersModel = model.users
    thermostatModel = model.thermostat
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
}
