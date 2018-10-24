//
//  AlertWindow.swift
//  Home
//
//  Created by Sebastien Villar on 5/27/18.
//  Copyright © 2018 -. All rights reserved.
//

import Foundation
import UIKit

class AlertController {

  // MARK: - Public

  static let shared = AlertController()

  func show(request: String, statusCode: Int, message: String) {
    let title = "Could not execute request: \(request)"
    let message = "Status: \(statusCode), message: \(message)"
    show(title: title, message: message)
  }

  func show(title: String, message: String? = nil) {
    let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
    controller.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
    show(controller)
  }

  func show(_ controller: UIAlertController) {
    guard let delegate = UIApplication.shared.delegate, let window = delegate.window else {
      return
    }

    guard rootVC.presentedViewController == nil else {
      return
    }

    alertWindow.isHidden = false
    alertWindow.frame = window?.frame ?? .zero
    alertWindow.makeKeyAndVisible()
    rootVC.dismissCallback = { [weak self] in
      self?.alertWindow.isHidden = true
      window?.makeKeyAndVisible()
    }

    rootVC.present(controller, animated: true, completion: nil)
  }

  // MARK: - Private

  private init() {}

  private lazy var alertWindow: UIWindow = {
    let window = UIWindow(frame: .zero)
    window.rootViewController = rootVC
    window.windowLevel = UIWindowLevelAlert
    window.isHidden = true
    return window
  }()

  private lazy var rootVC = AlertRootVC()
}

private class AlertRootVC: UIViewController {

  var dismissCallback: (() -> Void)?

  init() {
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
    let completionWrapper = { [weak self] in
      self?.dismissCallback?()
      completion?()
    }

    super.dismiss(animated: flag, completion: completionWrapper)
  }
}
