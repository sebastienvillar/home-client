//
//  LogsVC.swift
//  Home
//
//  Created by Sebastien Villar on 10/19/18.
//  Copyright © 2018 -. All rights reserved.
//

import Foundation
import UIKit
import WebKit

class LogsVC: UIViewController {

  // MARK: - Public

  var onCancel: (() -> Void)?

  init(model: LogsModel) {
    self.model = model
    super.init(nibName: nil, bundle: nil)

    navigationBarView.onCancel = { [weak self] in
      self?.onCancel?()
    }
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Super overrides

  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = .backgroundGray
    webView.isOpaque = false
    webView.backgroundColor = .clear
    view.addSubview(navigationBarView)
    view.addSubview(webView)

    // Prepare html
    let text = model.text.replacingOccurrences(of: "\n", with: "<br>")

    let style = [
      "background-color: \(UIColor.backgroundGray.hex)",
      "color: \(UIColor.foregroundWhite.hex)",
      "font-size: 14px",
    ].joined(separator: ";")

    let head = "<head><meta name=\"viewport\" content=\"width=device-width, initial-scale=1, minimum-scale=1\"></head>"
    let html = "<html>\(head)<body style=\"\(style)\">\(text)</body></html>"

    webView.loadHTMLString(html, baseURL: nil)
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()

    navigationBarView.sizeToFit()
    navigationBarView.frame = CGRect(
      x: 0,
      y: 0,
      width: view.width,
      height: navigationBarView.height
    )

    webView.frame = CGRect(
      x: 0,
      y: navigationBarView.bottom,
      width: view.width,
      height: view.height - navigationBarView.bottom
    )
  }

  // MARK: - Private

  private let navigationBarView = NavigationBarView()
  private let webView = WKWebView(frame: .zero)
  private let model: LogsModel
}
