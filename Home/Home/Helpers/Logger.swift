//
//  Logger.swift
//  Home
//
//  Created by Sebastien Villar on 04/04/2018.
//  Copyright © 2018 -. All rights reserved.
//

import Foundation

class Logger {

  // MARK: - Public

  static func info(_ message: String) {
    log(level: .error, message: message)
  }

  static func error(_ message: String) {
    log(level: .error, message: message)
  }

  // MARK: - Private

  private enum Level {
    case info
    case error
  }

  private static func log(level: Level, message: String) {
    let prefix: String = {
      switch level {
      case .info:
        return "Info"
      case .error:
        return "Error"
      }
    }()

    print("\(prefix): message")
  }
}
