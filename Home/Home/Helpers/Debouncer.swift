//
//  Debouncer.swift
//  Home
//
//  Created by Sebastien Villar on 10/23/18.
//  Copyright © 2018 -. All rights reserved.
//

import Foundation

class Debouncer {

  typealias Block = () -> Void

  // MARK: - Public

  init(duration: TimeInterval) {
    self.duration = duration
  }

  func debounce(_ block: @escaping Block) {
    self.block = block
    runIfNeeded()
  }
  

  // MARK: - Private

  private let duration: TimeInterval
  private var block: Block?
  private var lastRun = Date.distantPast
  private var runTimer: Timer?

  // MARK: Helpers

  private func runIfNeeded() {
    let now = Date()
    let interval = now.timeIntervalSince(lastRun)
    if interval > duration {
      block?()
      block = nil
      lastRun = now
    }
    else if runTimer == nil {
      runTimer = Timer.scheduledTimer(withTimeInterval: duration - interval, repeats: false) { [weak self] _ in
        self?.runTimer = nil
        self?.runIfNeeded()
      }
    }
  }
}
